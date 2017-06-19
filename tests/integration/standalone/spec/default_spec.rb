require "spec_helper"

class ServiceNotReady < StandardError
end

context "after provisioning finished" do
  describe server(:server1) do
    describe capybara("http://#{server(:server1).server.address}:8180") do
      it "shows Welcome to Jenkins!" do
        visit "/"
        expect(page).to have_content "Welcome to Jenkins!"
      end

      it "allows to login" do
        pending "Cannot click login button: https://github.com/teampoltergeist/poltergeist/issues/530"
        visit "/"
        click_link("Log in")
        fill_in("j_username", with: "admin")
        fill_in("j_password", with: "password")
        click_button("log in")
        find_button("log in").trigger("click")
        expect(page).to have_content "Please create new jobs to get started."
      end

      it "shows users" do
        visit "/"
        find_link("People").trigger("click")
        expect(page).to have_content "admin"
      end
    end
  end
end
