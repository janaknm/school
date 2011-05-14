package vat_stuff is

	-- data types for measurable attributes of the vat
	type temperature_type is delta 0.1  range 0.0 .. 100.0; 	-- degrees Celcius
	type depth_type       is delta 0.01 range 0.0 .. 5.0;	-- meters
	type salinity_type    is delta 0.1  range 0.0 .. 100.0;	-- gram per liter

	-- the extremes
	max_temp : constant temperature_type := 25.0;
	min_temp : constant temperature_type := 18.0;
	
	max_depth : constant depth_type := 4.0;
	min_depth : constant depth_type := 3.0;

	max_salinity : constant salinity_type := 20.0;
	min_salinity : constant salinity_type := 10.0;

	task type vat is
		-- controls
		-- add heat to the vat
		entry heat_on;
		entry heat_off;

		-- add water to the vat
		entry water_on;
		entry water_off;

		-- drain liquid from the vat
		entry drain_open;
		entry drain_closed;

		-- add brine to the vat
		entry brine_on;
		entry brine_off;

		-- measurements
		entry get_temperature (temperature : out temperature_type);
		entry get_depth       (depth       : out depth_type);
		entry get_salinity    (salinity    : out salinity_type);
	end vat;

end vat_stuff;
