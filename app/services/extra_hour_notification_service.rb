class ExtraHourNotificationService
  def self.call
    new.call
  end

  def call
    Company.all.each {|company| notify company }
  end

  private

  def notify(company)
    company_admins  = company.admin_users
    
    company.users.active.find_each do |user|
      dates = ExtraHourCalculator.call(user)

      if dates.present?
        company_admins.find_each do |admin|
          NotificationMailer.notify_admin_extra_hour(admin, user, dates)
        end
      end
    end
  end
end