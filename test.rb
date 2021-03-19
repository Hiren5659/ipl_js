# frozen_string_literal: true
require 'csv'
require 'json'

def top_n(hash, num)
  top_n = {}
  num.times do
    top_n[hash.max_by { |_k, v| v }[0]] = hash.max_by { |_k, v| v }[1]
    hash.delete(hash.max_by { |_k, v| v }[0])
  end
  top_n
end

# This method plot bar chart
def bar_chart(chart_code, max_val, min_val, y_inc, title, x_label, y_label, data, label, name)
  g = Gruff::Bar.new('800x700') # Define a custom size

  g.maximum_value = max_val # Declarg.data('Bar', [15, 3, 10])
  g.minimum_value = min_val # Declare a min value for the Y axis
  g.y_axis_increment = y_inc # Points shown on the Y axis

  g.theme = { # Declare a custom theme
    colors: %w[orange purple green white red #cccccc], # colors can be described on hex values (#0f0f0f)
    marker_color: 'black', # The horizontal lines color
    background_colors: %w[white grey] # you can use instead: :background_image => 'some_image.png'
  }

  g.title = title
  g.x_axis_label = x_label
  g.y_axis_label = y_label
  if chart_code.zero?
    g.data('', data)
  else
    data.each do |key, value|
      g.data(key, value)
    end
  end

  g.labels = label # Define labels for each of the "columns" in data

  g.write(name)
end

# calculating Total runs scored by team and run scored by rcb batsman
def total_run_by_team(deliveries)
  total_run_by_team = Hash.new(0)
  deliveries.each do |row|
    total_run_by_team[row['batting_team']] += row['total_runs'].to_i
  end
  total_run_by_team['Rising Pune Supergiants'] += total_run_by_team['Rising Pune Supergiant']
  total_run_by_team.delete('Rising Pune Supergiant')
  total_run_by_team.delete('Rising Pune Supergiants') unless total_run_by_team['Rising Pune Supergiants'] != 0
  total_run_by_team
end

def top5_rcb_batsman(deliveries)
  total_run_rcb_batsman = Hash.new(0)
  deliveries.each do |row|
    total_run_rcb_batsman[row['batsman']] += row['total_runs'].to_i unless \
      row['batting_team'] != 'Royal Challengers Bangalore'
  end
  top_n(total_run_rcb_batsman, 5)
end
# calaulating number of umpires by in IPL by country.

def umpires_by_country(umpires)
  umpires_by_country = Hash.new(0)
  umpires.each do |row|
    umpires_by_country[row['nationality']] += 1 unless row['nationality'] == 'India'
  end
  umpires_by_country
end

# Calculating no. of match played by team in each season
def matches_by_team_per_season(matches)
  matches_by_team_per_season = {}
  teams = []
  matches.each do |row|
    if row['team1'] != 'Rising Pune Supergiant' && row['team2'] != 'Rising Pune Supergiant'
      teams.append(row['team1']) unless teams.include?(row['team1'])
      teams.append(row['team2']) unless teams.include?(row['team2'])
    end
    matches_by_team_per_season[row['season']] = Hash.new(0) unless matches_by_team_per_season.key?(row['season'])
    matches_by_team_per_season[row['season']][row['team1']] += 1
    matches_by_team_per_season[row['season']][row['team2']] += 1

    next unless matches_by_team_per_season[row['season']].key('Rising Pune Supergiant')

    matches_by_team_per_season[row['season']]['Rising Pune Supergiants'] += \
      matches_by_team_per_season[row['season']]['Rising Pune Supergiant']
    matches_by_team_per_season[row['season']].delete('Rising Pune Supergiant')
    next
  end
  # create team_graph_data key=team value = []
  team_wise_graph_data = {}
  teams.each do |team|
    team_wise_graph_data[team] = []
  end
  # updte team_graph_data key=team value = [match played in each season]
  matches_by_team_per_season.each do |_key, value|
    teams.each do |team|
      if value.key?(team)
        team_wise_graph_data[team].append(value[team])
      else
        team_wise_graph_data[team].append(0)
      end
    end
  end
  [matches_by_team_per_season, team_wise_graph_data]
end

# Create label,data for graph from hash
def arr_of_hash_value(hmap)
  data = []
  hmap.each do |_key, value|
    data.append(value)
  end
  data
end


deliveries = CSV.parse(File.read('deliveries.csv'), headers: true)
umpires = CSV.parse(File.read('umpire.csv'), headers: true)
matches = CSV.parse(File.read('matches.csv'), headers: true)

foo = {}
seasons=[]
matches_by_team_per_season(matches)[1].each do |key,value|
  seasons.append({"name"=>key,"data"=>value})
end
teams=[]
total_run_by_team(deliveries).each do |key,value|
  teams.append([key,value])
end

rcb=[]
top5_rcb_batsman(deliveries).each do |key,value|
  rcb.append([key,value])
end

umpire=[]
umpires_by_country(umpires).each do |key,value|
  umpire.append([key,value])
end

foo['total_run_by_team'] = teams
foo['top5_rcb_batsman'] = rcb
foo['umpires_by_country'] = umpire
foo['matches_by_team_per_season'] = seasons

File.open('test.json', 'w') do |f|
  f << foo.to_json
end
