## Debugging documentation - Notification Dispatch System

This document tracks selected bugs encountered during the development and testing of the project and describes the root causes and fixes.

1. NoMethodError: undefined method '[]' for true

- Problematic line of code - @mock_channel.expect :send, true [arguments]
- Cause - Ruby interpreted true [arguments] as an attempt to access the key of the boolean true instead of reading it as the third argument of the expect method. 
- Fix - added the missing coma between true and [arguments] resolved the problem

2. ArgumentError: args ignored when block given
- Problematic line of code - @mock.expect :send, nil, [notification] do |n| ... end
- Cause - when we called the expect method on our mock object we passed notification as the third argument to specify that we want the send method to be called with that argument. However, because we also provided a block statement where we specified we want an error raised, Minitest expected us to manually verify the arguments inside that block. 
- Fix - Removed the 3rd argument array and moved the validation inside the block using assert_equal @notification, n.

3. Test passing even if logic was not correctly implemented
- Problem - I encountered a bug where I was testing dispatcher correctly dispatches an email notification via email channel. I used a mock object to create a mock email channel and specified which methods I expect to be called. However, at the end I forgot to call verify on the mock object to check if the given methods were actually called during the execution. The test passed even though the correct logic for the dispatch method was not yet implemented.
- Cause - when we call expect on a mock object, we specify the methods we exect to be called on the object. However, the actual testing happes only after we've verified that the methods were called using the verify method on the mock object.
- Fix - added @mock_email.verify
            @mock_sms.verify

