namespace :trespass do
    desc "Auto archive expired Trespass Notices"
    task :auto_archive => :environment do
        trespasses = Trespass.all
        trespasses.each do |trespass|
            if trespass.dateOfExpiration.past? && !trespass.archived
                trespass.update_attributes(archived: true)
            end
        end
    end
end