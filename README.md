# TodoList ReadMe

## Model Schemas:

### User:
* user_id (integer)
* has_many :todos
* name (varchar 25)
* email (varchar 50)
* password (varchar 255)

### Todo:
* todo_id (integer)
* belongs_to: :user
* task (varchar 255)
* completed (boolean)
