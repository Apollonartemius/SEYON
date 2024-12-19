from datetime import datetime, timedelta

class BookReturn:
    def __init__(self, issue_datetime, book_type):
        self.issue_datetime = issue_datetime
        self.book_type = book_type
        
        # Set the allowed borrowing period and fine rate based on book type
        if book_type == "general":
            self.allowed_days = 14  # 14 days allowed for general books
            self.fine_rate = 5  # ₹5 per day for late return
        elif book_type == "reference":
            self.allowed_days = 7  # 7 days allowed for reference books
            self.fine_rate = 10  # ₹10 per day for late return
        elif book_type == "magazine":
            self.allowed_days = 3  # 3 days allowed for magazines
            self.fine_rate = 2  # ₹2 per day for late return
        else:
            raise ValueError("Invalid book type")

        # Calculate the due date and time based on the allowed borrowing period
        self.due_datetime = self.issue_datetime + timedelta(days=self.allowed_days)

    def calculate_fine(self, return_datetime):
        # Calculate the difference between the return date and the due date
        delta = return_datetime - self.due_datetime
        fine = 0

        if delta.total_seconds() > 0:  # If the return is late
            # Calculate fine based on the total number of late days (partial days count as full)
            late_days = delta.days + (1 if delta.seconds > 0 else 0)
            fine = late_days * self.fine_rate

        return fine

    def display_due_info(self):
        # Display the allowed borrowing period and due date and time
        return (f"Book Type: {self.book_type.capitalize()}\n"
                f"Allowed period to keep the book: {self.allowed_days} days\n"
                f"The book is due by: {self.due_datetime.strftime('%Y-%m-%d %H:%M')}")

# Function to get datetime input (date + time) from user
def get_datetime_input(prompt):
    while True:
        try:
            # Taking input and converting to a datetime object
            datetime_input = input(prompt)
            datetime_object = datetime.strptime(datetime_input, "%Y-%m-%d %H:%M")
            return datetime_object
        except ValueError:
            print("Invalid format! Please enter the date and time in 'YYYY-MM-DD HH:MM' format.")

# Function to get book type input from user
def get_book_type_input():
    while True:
        book_type = input("Enter the book type (general/reference/magazine): ").lower()
        if book_type in ["general", "reference", "magazine"]:
            return book_type
        else:
            print("Invalid book type! Please choose from general, reference, or magazine.")

# Start of program loop
while True:
    print("\nWelcome to the Library Book Issue System")
    
    # Option to exit the loop
    action = input("Type 'exit' to leave or press Enter to continue: ").lower()
    if action == "exit":
        print("Exiting the library system. Goodbye!")
        break

    # Get issue date from the user
    issue_datetime = get_datetime_input("Enter the issue date and time (YYYY-MM-DD HH:MM): ")

    # Get book type from the user
    book_type = get_book_type_input()

    # Create a BookReturn object (issue date and book type)
    book = BookReturn(issue_datetime, book_type)

    # Display the due date and borrowing period information
    due_info = book.display_due_info()
    print("\n" + due_info)

    # Prompt the user to return the book and get the return date
    return_datetime = get_datetime_input("\nEnter the return date and time (YYYY-MM-DD HH:MM): ")

    # Calculate if there is a fine for late return
    fine = book.calculate_fine(return_datetime)

    # Display the fine if applicable, or inform the user the book was returned on time
    if fine > 0:
        print(f"\nLate return detected! Fine for returning the {book_type} book is: ₹{fine}")
    else:
        print(f"\nNo fine. {book_type.capitalize()} book returned on time or earlier.")

