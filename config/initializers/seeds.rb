# Convenience methods for console
#
if Rails.env.development?
  def admin;  User.find_by_email('admin@admin.com');  end
  def jeff;   User.find_by_email('jeff@gmail.com');   end
  def david;  User.find_by_email('david@gmail.com');  end
  def nicole; User.find_by_email('nicole@gmail.com'); end
end
