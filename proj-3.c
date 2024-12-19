#include <stdio.h>
#include <string.h>

// Structure for light control
struct Light {
    int isOn;
    int brightness;
};

// Structure for security system
struct SecuritySystem {
    int isArmed;
};

// Union to hold either light or security system data
union DeviceControl {
    struct Light light;
    struct SecuritySystem security;
};

// Function to save device data to a file
void saveToFile(const char *filename, union DeviceControl device) {
    FILE *file = fopen(filename, "wb");
    if (file != NULL) {
        fwrite(&device, sizeof(union DeviceControl), 1, file);
        fclose(file);
        printf("\nDevice data saved to file successfully.\n");
    } else {
        printf("\nError opening file for writing.\n");
    }
}

// Function to load device data from a file
void loadFromFile(const char *filename, union DeviceControl *device) {
    FILE *file = fopen(filename, "rb");
    if (file != NULL) {
        fread(device, sizeof(union DeviceControl), 1, file);
        fclose(file);
        printf("\nDevice data loaded from file.\n");
    } else {
        printf("\nError opening file for reading.\n");
    }
}

int main() {
    union DeviceControl device;
    int filecode, loadcode, passcode, choice;

    printf("Welcome to the Smart Forest Device Control System!\n");

    while (1) {
        printf("\n1. Control Lights\n");
        printf("2. Control Security System\n");
        printf("3. Save Device Data to File\n");
        printf("4. Load Device Data from File\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                printf("\nLights Control Menu\n");
                printf("Is the light on? (1 for On, 0 for Off): ");
                scanf("%d", &device.light.isOn);

                if (device.light.isOn == 1) {
                    printf("\nThe Light is ON\n");
                    printf("Brightness for your light (0-100): ");
                    scanf("%d", &device.light.brightness);

                    // Check the brightness level and print a message accordingly
                    if (device.light.brightness >= 0 && device.light.brightness <= 30) {
                        printf("\nThe light is glowing weakly.\n");
                    } else if (device.light.brightness >= 31 && device.light.brightness <= 50) {
                        printf("\nThe light is glowing moderately.\n");
                    } else if (device.light.brightness >= 51 && device.light.brightness <= 75) {
                        printf("\nThe light is glowing strongly.\n");
                    } else if (device.light.brightness >= 76 && device.light.brightness <= 100) {
                        printf("\nThe light is glowing very brightly.\n");
                    } else {
                        printf("\nInvalid brightness value! Please enter a value between 0 and 100.\n");
                    }
                } else {
                    printf("\nThe light is OFF\n");
                }
                break;

            case 2:
                printf("\nSecurity System Control Menu\n");
                printf("Is the security system armed? (1 for Armed, 0 for Disarmed): ");
                scanf("%d", &device.security.isArmed);
                if (device.security.isArmed == 1) {
                    printf("\nYour system is getting a shield, but need a passcode to activate.\n");
                    printf("Enter passcode: ");
                    scanf("%d", &passcode);
                    if (passcode != 30102005) {
                        printf("\nOH SORRY! But the passcode is wrong.\n");
                        printf("Your system is still unprotected, shield your system immediately!\n");
                    } else {
                        printf("\nYour shield is activated! Your system and data are protected.\n");
                    }
                } else {
                    printf("\nYour system is unprotected, shield your system immediately!\n");
                }
                break;

            case 3:
                printf("Enter filecode to save data: ");
                scanf("%d", &filecode);
                if (filecode != 3010) {
                    printf("\nThe entered filecode is wrong. Please try again.\n");
                    saveToFile("\ndevice_data.bin", device);
                } else {
                    saveToFile("device_data.bin", device);
                }
                break;

            case 4:
                printf("Enter filecode to load data: ");
                scanf("%d", &loadcode);
                if (loadcode != 2005) {
                    printf("\nThe entered filecode is wrong. Please try again.\n");
                    loadFromFile("\ndevice_data.bin", &device);
                } else {
                    loadFromFile("device_data.bin", &device);
                }
                break;

            case 5:
                printf("Exiting...\n");
                return 0;

            default:
                printf("Invalid choice. Please enter a valid option.\n");
                break;
        }
    }

    return 0;
}
