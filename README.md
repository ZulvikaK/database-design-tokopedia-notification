# Tokopedia Notification Database Design 
This database is designed to handle notifications and inbox functionalities for a Tokopedia-like platform. It supports features like categorized notifications, read/unread status, and counters for unread notifications. Below is an overview of its key components:

## Core Features
- Inbox/Notification Management:
Stores user-specific notifications and global notifications.
Allows notifications to be personalized based on user actions (e.g., order updates, promotions).
- Read/Unread Status:
Tracks whether a user has read a specific notification.
Enables dynamic updates for unread notification counters.
- Categories:
Organizes notifications into categories such as promotions, transactions, or general information.
Facilitates filtering by category for better user experience.
- Unread Counter:
Provides a quick count of unread notifications for each user.
Automatically updates when notifications are marked as read.

