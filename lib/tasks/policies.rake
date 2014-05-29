
desc "Applies all policies that should be applied"
task :apply_policies => :environment do
  puts 'Starting Jobs::ApplyPolicies.apply_all...'
  Jobs::ApplyPolicies.apply_all
  puts 'Jobs::ApplyPolicies.apply_all done.'
end
