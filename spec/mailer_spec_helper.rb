require 'spec_helper'

module MailerSpecHelper
  private

  def read_mailer_fixture(mailer, action)
    IO.read("spec/fixtures/mailers/#{mailer.name.underscore}/#{action}")
  end
end