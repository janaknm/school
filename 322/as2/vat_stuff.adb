with Ada.Numerics.Float_Random;
use  Ada.Numerics.Float_Random;

with Ada.Text_IO;
use  Ada.Text_IO;

package body vat_stuff is

	-- only one brine source and water source
	type valve_state is (open, closed);
	
	protected type valve is
		procedure on;
		procedure off;
		function is_on  return boolean;
		function is_off return boolean;
	private
		state : valve_state := closed;
	end valve;

	protected body valve is
		procedure on is
		begin
			state := open;
		end on;

		procedure off is
		begin
			state := closed;
		end off;

		function is_on return boolean is
		begin
			return state = open;
		end is_on;

		function is_off return boolean is
		begin
			return state = closed;
		end is_off;
	end valve;

	water_valve, 
	brine_valve : valve;

	-- exceptions raised by the vat
	batch_ruined,
	vat_exploded,
	vat_overflow : exception;


	task body vat is
		-- data values of measurable attributes of the vat
		current_temperature : temperature_type;
		current_depth       : depth_type;
		current_salinity    : salinity_type;

		-- state of controls
		heat_is_on       : boolean := false;
		water_is_flowing : boolean := false;
		drain_is_open    : boolean := false;
		brine_is_flowing : boolean := false;

		-- random number generator
		gen : generator;

		-- ranges
		temp_range     : temperature_type := max_temp - min_temp;
		depth_range    : depth_type       := max_depth - min_depth;
		salinity_range : salinity_type    := max_salinity - min_salinity;
	begin
		-- initialization
		reset(gen);
		current_temperature := min_temp + temperature_type(0.2) * temp_range 
							            + temperature_type(0.6 * random(gen)) * temp_range;
		current_depth       := min_depth + depth_type(0.2) * depth_range
		                                 + depth_type(0.6 * random(gen)) * depth_range;
		current_salinity    := min_salinity + salinity_type(0.2) * salinity_range
		                                    + salinity_type(0.6 * random(gen)) * salinity_range;
		
		loop
			-- check controls
			select
				accept heat_on;
				heat_is_on := true;
			or
				accept heat_off;
				heat_is_on := false;
			or
				accept water_on;
				if water_valve.is_off and brine_valve.is_off then
					water_is_flowing := true;
				end if;
			or
				accept water_off;
				if water_valve.is_on then
					water_is_flowing := false;
				end if;
			or
				accept drain_open;
				drain_is_open := true;
			or
				accept drain_closed;
				drain_is_open := false;
			or
				accept brine_on;
				if brine_valve.is_off and water_valve.is_off then
					brine_is_flowing := true;
				end if;
			or
				accept brine_off;
				if brine_valve.is_on then
					brine_is_flowing := false;
				end if;
			else
				null;
			end select;

			-- check for reading requests
			select
				accept get_temperature (temperature : out temperature_type) do
					temperature := temperature_type(float(current_temperature) 
					             + (0.05 * (random(gen) - 0.5)) * float(temp_range));
				end get_temperature;
			or
				accept get_depth (depth : out depth_type) do
					depth := depth_type(float(current_depth)
					       + (0.05 * (random(gen) - 0.5)) * float(depth_range));
				end get_depth;
			or
				accept get_salinity (salinity : out salinity_type) do
					salinity := salinity_type(float(current_salinity)
					          + (0.05 * (random(gen) - 0.5)) * float(salinity_range));
				end get_salinity;
			else
				null;
			end select;

			-- check for settings outside range
			if current_temperature > max_temp or else
			   current_temperature < min_temp then
				raise batch_ruined;
			end if;

			if current_salinity > max_salinity or else
			   current_salinity < min_salinity then
				raise batch_ruined;
			end if;

			if current_depth > max_depth then
				raise vat_overflow;
			end if;

			if current_depth < min_depth and then heat_is_on then
				raise vat_exploded;
			end if;
			
			-- make adjustments
			if heat_is_on then 
				current_temperature := current_temperature + temperature_type(1.0 + 0.5 * random(gen));
				current_salinity    := current_salinity    + salinity_type(0.5 + 0.1 * random(gen));
			else
				current_temperature := current_temperature - temperature_type(0.2 + 0.1 * random(gen));
			end if;

			if water_is_flowing then
				current_depth := current_depth + depth_type(0.5 + 0.1 * random(gen));
				current_temperature := current_temperature - temperature_type(0.1 + 0.1 * random(gen));
				current_salinity    := current_salinity    - salinity_type(1.0 + 0.5 * random(gen));
			end if;

			if drain_is_open then
				current_depth := current_depth - depth_type(1.0 + 0.2 * random(gen));
			end if;

			if brine_is_flowing then
				current_salinity    := current_salinity    + salinity_type(2.0 + 0.4 * random(gen));
				current_depth := current_depth + depth_type(0.5 + 0.1 * random(gen));
				current_temperature := current_temperature - temperature_type(0.1 + 0.1 * random(gen));
			end if;

			delay Duration(random(gen));
				
		end loop;

	exception
		when batch_ruined => Put_line("Batch ruined");
		when vat_overflow => Put_line("Vat overflow");
		when vat_exploded => Put_line("Vat_exploded");
	
	end vat;

end vat_stuff;
