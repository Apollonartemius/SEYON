#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NAME_SIZE 50  // Maximum length of the customer's name

// Node structure for the dynamic queue
typedef struct Node {
    int customerID;
    char customerName[NAME_SIZE];
    struct Node* next;
} Node;

// Queue structure
typedef struct {
    Node* front;
    Node* rear;
} Queue;

// Initialize the queue
void initQueue(Queue* q) {
    q->front = q->rear = NULL;
}

// Check if the queue is empty
int isEmpty(Queue* q) {
    return q->front == NULL;
}

// Enqueue (Add a customer to the queue)
void enqueue(Queue* q, int customerID, char* customerName) {
    Node* newNode = (Node*)malloc(sizeof(Node));
    if (!newNode) {
        printf("Memory allocation error!\n");
        return;
    }
    newNode->customerID = customerID;
    strcpy(newNode->customerName, customerName);
    newNode->next = NULL;
    
    if (q->rear == NULL) {
        q->front = q->rear = newNode;
    } else {
        q->rear->next = newNode;
        q->rear = newNode;
    }
    
    printf("Customer %d (%s) added to the queue.\n", customerID, customerName);
}

// Dequeue (Serve the customer)
int dequeue(Queue* q) {
    if (isEmpty(q)) {
        printf("Queue is empty! No customers are waiting.\n");
        return -1;
    }
    Node* temp = q->front;
    int customerID = temp->customerID;
    
    printf("Customer %d (%s) is being served.\n", customerID, temp->customerName);
    
    q->front = q->front->next;
    
    if (q->front == NULL) {
        q->rear = NULL;
    }
    
    free(temp);
    return customerID;
}

// Display the current queue
void displayQueue(Queue* q) {
    if (isEmpty(q)) {
        printf("Queue is empty! No customers are waiting.\n");
        return;
    }
    
    Node* temp = q->front;
    printf("Current queue:\n");
    while (temp) {
        printf("Customer ID: %d, Name: %s\n", temp->customerID, temp->customerName);
        temp = temp->next;
    }
    printf("\n");
}

// Check the next customer without serving them
void checkNextCustomer(Queue* q) {
    if (isEmpty(q)) {
        printf("Queue is empty! No customers are waiting.\n");
    } else {
        printf("Next customer to be served: %d (%s)\n", q->front->customerID, q->front->customerName);
    }
}

// Cancel reservation by customer ID
void cancelReservation(Queue* q, int customerID) {
    if (isEmpty(q)) {
        printf("Queue is empty! No customers are waiting.\n");
        return;
    }
    
    Node* temp = q->front;
    Node* prev = NULL;
    
    while (temp != NULL && temp->customerID != customerID) {
        prev = temp;
        temp = temp->next;
    }
    
    if (temp == NULL) {
        printf("Customer ID %d not found in the queue.\n", customerID);
        return;
    }
    
    printf("Reservation for Customer %d (%s) has been cancelled.\n", customerID, temp->customerName);
    
    if (prev == NULL) {
        q->front = temp->next;
    } else {
        prev->next = temp->next;
    }
    
    if (q->rear == temp) {
        q->rear = prev;
    }
    
    free(temp);
}

// Main function to simulate the ticket reservation system
int main() {
    Queue q;
    initQueue(&q);
    int choice, customerID;
    char customerName[NAME_SIZE];

    do {
        printf("\nTicket Reservation System\n");
        printf("1. Add Customer to Waiting Queue\n");
        printf("2. Serve Customer (Reserve Ticket)\n");
        printf("3. Display Queue\n");
        printf("4. Check Next Customer\n");
        printf("5. Cancel Reservation\n");
        printf("6. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                printf("Enter Customer ID: ");
                scanf("%d", &customerID);
                printf("Enter Customer Name: ");
                scanf(" %[^\n]s", customerName);  // Use %[^\n]s to take string with spaces
                enqueue(&q, customerID, customerName);
                break;
            case 2:
                dequeue(&q);
                break;
            case 3:
                displayQueue(&q);
                break;
            case 4:
                checkNextCustomer(&q);
                break;
            case 5:
                printf("Enter Customer ID to cancel reservation: ");
                scanf("%d", &customerID);
                cancelReservation(&q, customerID);
                break;
            case 6:
                printf("Exiting the system.\n");
                break;
            default:
                printf("Invalid choice! Please try again.\n");
        }
    } while (choice != 6);

    return 0;
}
