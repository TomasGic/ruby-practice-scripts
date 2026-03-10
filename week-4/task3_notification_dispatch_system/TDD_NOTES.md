## Testing process
This project uses a Test Driven Development (TDD) approach which follows the Red/Green/Refactor loop. 

- Red phase - we define a rule or a behaviour and write a test to test that behaviour. The test will fail at first because we have not implemented the behaviour yet. 
- Green phase - We write the minimum amount of code to make the test pass. 
- Refactor phase - Later we refactor the code to add more features/complexity and we make sure that our test still passes. 

Below are some notes to describe the red/green/refactor loop for selected tests from the project's test suite

# Happy path: Email routing (dispatcher dispatches email notification via email channel)
Red phase - created a test where two mock channels (email, sms) were passed to the dispatcher object. The test failed because we have not yet implemented Disptacher class and the channel routing logic

Green phase - We created Dispatcher class and within the class we implemented @channels.find { |ch| ch.supports?(notification) }. This iterates through the channels passed to the dispatcher until it finds the channel that matches the notification type. 

Refactor - later we implemented the Channel classes (EmailChannel and SmsChannel). Our test still passed because in our test we didn't use actual channel objects but only mocks.

# System rule enforced: Dispatcher will not dispatch notification with empty message (EmptyMessageError is raised)
Red phase - In our test we create a notification object containing an empty message string (""). When we call dispatch on our dispatcher we expect EmptyMessageError to be raised. The test will fail because we have not implemented EmptyMessageError yet.

Green - In the Dispatcher class we implement 
if notification.message.nil? || notification.message.strip.empty?
    raise EmptyMessageError, "Message cannot be empty"

Refactor - later we add a full begin/rescue block into our dispatcher to catch other types of errors. The check whether notification message is empty we created earlier should now be moved into the begin/rescue block. After refactoring the test should still pass.

# Edge case: invalid recipient for email notification. 
Red phase - in our test we create a notification object with invalid email address (missing @ symbol). We assert we want an InvalidRecipientError to be raised. The test fails because we have neither created that custom error class nor implemented a regex pattern matching for email address.

Green - we create a custom error class InvalidRecipientError and implement a validate_email method in our EmailChannel class where we check our notification's email address against a regex email pattern. 

Refactor - we update our regex pattern to also match email addresses with more than one domain (for example .co.uk). Our test should still pass. 

