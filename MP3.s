#include <stdio.h>
#include <string.h>

int calc_decimal(char hex_str[]);

int main() {
    char hex_input[10];
    printf("Enter a hexadecimal value.\n");
    
    fgets(hex_input, sizeof(hex_input), stdin);
    
    // Check for valid input
    if (strlen(hex_input) > 9) {
        printf("More than 8 hex digits entered.\n");
        return 1;
    }
    
    // Call the conversion function
    int decimal_value = calc_decimal(hex_input);
    
    // Check for invalid hex digit
    if (decimal_value == -1) {
        return 1; // An invalid hex digit was found
    }
    
    printf("The hexadecimal number entered is the decimal value: %d\n", decimal_value);
    return 0;
}

int calc_decimal(char hex_str[]) {
    int decimal_value = 0;
    for (int i = 0; hex_str[i] != '\n' && hex_str[i] != '\0'; i++) {
        char c = hex_str[i];
        int value;
        if (c >= '0' && c <= '9') {
            value = c - '0';
        } else if (c >= 'a' && c <= 'f') {
            value = c - 'a' + 10;
        } else {
            printf("Invalid hex digit: %c\n", c);
            return -1; // Invalid hex digit
        }
        decimal_value = (decimal_value << 4) | value; // Shift left and add new value
    }
    return decimal_value;
}
