# frozen_string_literal: true

require 'asana'
require 'dotenv'

Dotenv.load

def run_sample
  client = Asana::Client.new do |c|
    c.authentication :access_token, ENV['PERSONAL_TOKEN']
  end

  workspace = client.workspaces.get_workspaces.find { |workspace| workspace.name == ENV['WORKSPACE'] }
  user = client.users.get_users.find { |user| user.name == ENV['USER_NAME'] }
  team = client.teams.get_teams_for_user(user_gid: user.gid, organization: workspace.gid).find { |team| team.name == ENV['TEAM'] }
  project = client.projects.get_projects_for_team(team_gid: team.gid).find { |project| project.name == 'Test Project' }

  if project.nil?
    project = client.projects.create_project(name: 'Test Project', workspace_gid: workspace.gid, team: team.gid)
  end

  task = client.tasks.create_task(name: "Task #{Time.now}", workspace: workspace.gid, projects: [project.gid])

  puts "#{task.name} created successfully!"
end

run_sample
