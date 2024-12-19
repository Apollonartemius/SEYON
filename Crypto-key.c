#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_COEFFICIENTS 10   // Maximum polynomial size for simplicity

// Function to generate a random polynomial
void generate_polynomial(int *coefficients, int degree) {
    for (int i = 0; i <= degree; i++) {
        coefficients[i] = rand() % 256;  // Random coefficients between 0 and 255
    }
}

// Function to print the polynomial
void print_polynomial(int *coefficients, int degree) {
    for (int i = degree; i >= 0; i--) {
        printf("%d*x^%d", coefficients[i], i);
        if (i > 0) {
            printf(" + ");
        }
    }
    printf("\n");
}

// Function to add two polynomials
void add_polynomials(int *poly1, int *poly2, int *result, int degree1, int degree2) {
    int max_degree = (degree1 > degree2) ? degree1 : degree2;
    for (int i = 0; i <= max_degree; i++) {
        int coef1 = (i <= degree1) ? poly1[i] : 0;
        int coef2 = (i <= degree2) ? poly2[i] : 0;
        result[i] = coef1 + coef2;
    }
}

// Function to multiply two polynomials
void multiply_polynomials(int *poly1, int *poly2, int *result, int degree1, int degree2) {
    int degree_result = degree1 + degree2;
    for (int i = 0; i <= degree_result; i++) {
        result[i] = 0;
    }
    for (int i = 0; i <= degree1; i++) {
        for (int j = 0; j <= degree2; j++) {
            result[i + j] += poly1[i] * poly2[j];
        }
    }
}

// Function to convert a polynomial result into an 8-digit hexadecimal key
void convert_to_hex(int *result, int degree, char *hex_key) {
    unsigned long long int value = 0;
    for (int i = 0; i <= degree; i++) {
        value += result[i] * (1 << (8 * i));  // Combine coefficients with powers of 256
    }
    sprintf(hex_key, "%08llx", value);  // Convert to 8-digit hexadecimal
}

int main() {
    srand((unsigned int)time(NULL));
    
    // Passcode verification
    int passcode;
    printf("Enter passcode to access key data (6 digits): ");
    scanf("%d", &passcode);

    if (passcode != 301005) {
        printf("Passcode incorrect. Access denied.\n");
        return 1;
    }

    printf("Passcode correct. Access granted.\n");

    // Polynomial degrees input
    int degree1, degree2;
    printf("Enter the degree of the first polynomial (key1): ");
    scanf("%d", &degree1);

    printf("Enter the degree of the second polynomial (key2): ");
    scanf("%d", &degree2);

    // Initialize polynomials
    int poly1[MAX_COEFFICIENTS] = {0};
    int poly2[MAX_COEFFICIENTS] = {0};
    int result_add[MAX_COEFFICIENTS] = {0};
    int result_multiply[MAX_COEFFICIENTS * 2] = {0};  // Larger size for multiplication

    // Generate random polynomials
    generate_polynomial(poly1, degree1);
    generate_polynomial(poly2, degree2);

    // Display original polynomials
    printf("\nOriginal Keys:\n");
    print_polynomial(poly1, degree1);
    print_polynomial(poly2, degree2);

    // Add the polynomials
    add_polynomials(poly1, poly2, result_add, degree1, degree2);

    // Multiply the polynomials
    multiply_polynomials(poly1, poly2, result_multiply, degree1, degree2);

    // Display polynomial addition and multiplication results
    printf("\nPolynomial Addition Result:\n");
    print_polynomial(result_add, (degree1 > degree2) ? degree1 : degree2);

    printf("\nPolynomial Multiplication Result:\n");
    print_polynomial(result_multiply, degree1 + degree2);

    // Generate 8-digit private key in hexadecimal
    char hex_key[9] = {0};
    convert_to_hex(result_add, (degree1 > degree2) ? degree1 : degree2, hex_key);

    // Display the generated 8-digit key
    printf("\nGenerated 8-digit Key (in hexadecimal): %s\n", hex_key);

    return 0;
}
