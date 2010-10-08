#include <iomanip>
#include <iostream>
using namespace std;

// function declarations
bool getLoanInfo(double& loan_amt, double& interest, double& payment);
void runLoanCalculator(double loan_amt, double interest, double payment);
double round(double d, int digits);

//template declarations
template<class T>
bool get(T& rv, string message);

//entry
int main(int argc, char **argv) {
	double loan_amt,
		   interest,
		   payment;
	bool success;

	//setup cout
	cout.setf(ios::fixed);

	//was input extracted successfuly?
	success = getLoanInfo(loan_amt, interest, payment);
	
	if(!success) {
		cout << "Please rerun the program with correct input." << endl;
	} else {
		runLoanCalculator(loan_amt, interest, payment);
	}

	return 0;
}

//Inquires for loan information
bool getLoanInfo(double& loan_amt, double& interest, double& payment) {
	bool success;

	success = get<double>(loan_amt, "Initial loan amount: ");
	if(!success) return false;

	success = get<double>(interest, "Annual Interest rate: ");
	if(!success) return false;

	success = get<double>(payment, "Monthly payment: ");
	if(!success) return false;

	return true;
}

void runLoanCalculator(double loan_amt, double interest, double payment) {
	double m_interest = interest / 12,
		   balance = loan_amt,
		   interest_amt = m_interest * balance,
		   interest_paid=0,
		   total_paid=0,
		   last_payment=0;
	int numPayments=0;
	
	if(payment <= interest_amt) {
		cout << "Impossible to pay off loan." << endl; 
	} else {
		cout << setw(8) << "Month";
		cout << setw(12) << "Principle";
		cout << setw(10) << "Interest";
		cout << endl;
		while(balance > 0) {
			numPayments++;
			interest_amt = round(m_interest * balance, 2);

			cout.precision(2);
			cout << setw(8) << numPayments;
			cout << setw(12) << balance;
			cout << setw(10) << interest_amt << endl;

			balance += interest_amt;
			if(payment > balance) {
				last_payment = balance;
			} else {
				last_payment = payment;
			}
			balance -= last_payment;
			interest_paid += interest_amt;
			total_paid += last_payment;
		}
		cout << "Principle: $" << loan_amt << endl;
		cout << "Rate: " << interest << "%" << endl;
		cout << numPayments-1 << " payments of $" << payment << ", last payment of $" << last_payment << endl;
		cout << "Total interest paid: $" << interest_paid << endl;
		cout << "Total repaied: $" << total_paid << endl;
	}

}

double round(double d, int digits) {
	int base = (int)d;
	double change = ((int)( (d-base)*100));
	return base + double(change / 100);
}

template<class T>
bool get(T& rv, string message) {
	int tries=5;
	bool success=false;
	char line[256];
	while( tries-- && !success) {
		cout << message;
		cin >> rv;
		if(cin.fail()) {
			cin.clear();
			cin.getline(line, 256);
			cout << "Invalid input, you have " << tries << " attempts remaining." << endl;
		} else {
			success = true;
		}
	}
	return success;
}
