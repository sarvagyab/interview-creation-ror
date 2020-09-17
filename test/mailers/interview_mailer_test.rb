require 'test_helper'

class InterviewMailerTest < ActionMailer::TestCase
  test "newInterview" do
    mail = InterviewMailer.newInterview
    assert_equal "Newinterview", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
