def tick args
  args.state.current_scene ||= :title_scene

  current_scene = args.state.current_scene

  case current_scene
  when :title_scene
    tick_title_scene args
  when :game_scene
    tick_game_scene args
  when :game_over_scene
    tick_game_over_scene args
  end

  if args.state.current_scene != current_scene
    raise "Scene was changed incorrectly. Set args.state.next_scene to change scenes."
  end

  if args.state.next_scene
    args.state.current_scene = args.state.next_scene
    args.state.next_scene = nil
  end
end

def make_enemies_small_left
  enemies_small_left = []
  enemies_small_left += 1.times.map { |n| {x: 400, y: 780, w: 32, h: 32, health: 30, path: 'sprites/enemyplane1.png'} }
  enemies_small_left += 1.times.map { |n| {x: 400, y: 840, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_left += 1.times.map { |n| {x: 400, y: 900, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_left += 1.times.map { |n| {x: 400, y: 960, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_left += 1.times.map { |n| {x: 400, y: 1020, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_left
end

def make_enemies_small_right
  enemies_small_right = []
  enemies_small_right += 1.times.map { |n| {x: 800, y: 780, w: 32, h: 32, health: 30, path: 'sprites/enemyplane1.png'} }
  enemies_small_right += 1.times.map { |n| {x: 800, y: 840, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_right += 1.times.map { |n| {x: 800, y: 900, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_right += 1.times.map { |n| {x: 800, y: 960, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_right += 1.times.map { |n| {x: 800, y: 1020, w: 32, h: 32, health: 20, path: 'sprites/enemyplane2.png'} }
  enemies_small_right
end

def make_enemies_medium_center
  enemies_medium_center = []
  enemies_medium_center += 1.times.map { |n| {x: 600, y: 780, w: 128, h: 24, health: 100, path: 'sprites/enemy_plane_medium_1.png'} }
  enemies_medium_center
end

def update_explosions args
  args.state.explosions.each do |explosion|
    explosion[:age]  += 0.5
    explosion[:path] = "sprites/explosion-#{explosion[:age].floor}.png"
  end
  args.state.explosions = args.state.explosions.reject { |explosion| explosion[:age] >= 7 }

  args.state.explosions_small.each do |explosion|
    explosion[:age]  += 0.5
    explosion[:path] = "sprites/explosion-#{explosion[:age].floor}.png"
  end
  args.state.explosions_small = args.state.explosions_small.reject { |explosion| explosion[:age] >= 7 }
end

def update_enemy_positions args
  args.state.enemies_small_left.each do |enemy|
    enemy[:y] -= 2
    if enemy[:y] < 680
      enemy[:x] += 1
    end

    args.state.enemies_small_left = args.state.enemies_small_left.reject do |enemy|
      if enemy[:y] < -64
        true
      else
        false
      end
    end
  end
  args.state.enemies_small_right.each do |enemy|
    enemy[:y] -= 2
    if enemy[:y] < 680
      enemy[:x] -= 1
    end

    args.state.enemies_small_right = args.state.enemies_small_right.reject do |enemy|
      if enemy[:y] < -64
        true
      else
        false
      end
    end
  end
  args.state.enemies_medium_center.each do |enemy|
    enemy[:y] -= 1

    args.state.enemies_medium_center = args.state.enemies_medium_center.reject do |enemy|
      if enemy[:y] < -64
        true
      else
        false
      end
    end
  end
end

def tick_title_scene args
  args.outputs.background_color = [0, 0, 0]
  args.outputs.labels << [460, 500, "20 Second Strike", 15, 255, 255, 255, 255]
  args.outputs.labels << [380, 400, "Press the Enter key to start.", 10, 255, 255, 255, 255]
  args.outputs.labels << [570, 300, "Controls:", 10, 255, 255, 255, 255]
  args.outputs.labels << [480, 250, "w,a,s,d = Movement.", 10, 255, 255, 255, 255]
  args.outputs.labels << [540, 200, "Space = Fire.", 10, 255, 255, 255, 255]

  if args.inputs.keyboard.enter
    args.state.next_scene = :game_scene
  end
end

def tick_game_scene args
  args.state.explosions     ||= []
  args.state.explosions_small         ||=[]
  args.state.enemies_small_left        ||= []
  args.state.enemies_small_right        ||= []
  args.state.enemies_medium_center        ||= []
  args.state.score          ||= 0
  if args.state.enemies_small_left.empty?
    args.state.enemies_small_left = make_enemies_small_left
  end
  if args.state.enemies_small_right.empty?
    args.state.enemies_small_right   = make_enemies_small_right
  end
  if args.state.enemies_medium_center.empty?
    args.state.enemies_medium_center   = make_enemies_medium_center
  end
  args.state.player         ||= {x: 620, y: 80, w: 63, h: 51, path: 'sprites/playerplane1.png', angle: 0, cooldown: 0, alive: true}
  args.state.enemy_bullets  ||= []
  args.state.player_bullets_1 ||= []
  args.state.player_bullets_2 ||= []
  args.state.time_seconds   ||= 20
  args.state.time_frame     ||= 0

  if args.state.time_seconds > 0
    args.state.time_frame += 1
  end

  if args.state.time_seconds == 0
    args.state.next_scene = :game_over_scene
  end

  if args.state.time_frame == 59
    args.state.time_frame = 0
    args.state.time_seconds -= 1
  end

  update_explosions args
  update_enemy_positions args

  # Handle user input.
  if args.inputs.left && args.state.player[:x] > (300 + 5)
    args.state.player[:x] -= 5
  end
  if args.inputs.right && args.state.player[:x] < (1280 - args.state.player[:w] - 300 - 5)
    args.state.player[:x] += 5
  end
  if args.inputs.up && args.state.player[:y] < (720 - args.state.player[:h] - 0 - 5)
    args.state.player[:y] += 5
  end
  if args.inputs.down && args.state.player[:y] > (0 + 5)
    args.state.player[:y] -= 5
  end

  args.state.enemy_bullets.each do |bullet|
    bullet[:x] += bullet[:dx]
    bullet[:y] += bullet[:dy]
  end
  args.state.player_bullets_1.each do |bullet|
    bullet[:x] += bullet[:dx]
    bullet[:y] += bullet[:dy]
  end
  args.state.player_bullets_2.each do |bullet|
    bullet[:x] += bullet[:dx]
    bullet[:y] += bullet[:dy]
  end

  # Check state of player bullets to see if any bullets missed enemies.
  args.state.enemy_bullets  = args.state.enemy_bullets.find_all { |bullet| bullet[:y].between?(-16, 736) }
  args.state.player_bullets_1 = args.state.player_bullets_1.find_all do |bullet|
    if bullet[:y].between?(-16, 736)
      true
    else
      false
    end
  end
  args.state.player_bullets_2 = args.state.player_bullets_2.find_all do |bullet|
    if bullet[:y].between?(-16, 736)
      true
    else
      false
    end
  end

  # Player and enemy collision detection.
  args.state.enemies_small_left = args.state.enemies_small_left.reject do |enemy|
    if args.state.player[:alive] && 1500 > (args.state.player[:x] - enemy[:x]) ** 2 + (args.state.player[:y] - enemy[:y]) ** 2
      args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
      args.state.explosions << {x: args.state.player[:x] + 4, y: args.state.player[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
      args.state.player[:alive] = false
      true
    else
      false
    end
  end
  args.state.enemies_small_right = args.state.enemies_small_right.reject do |enemy|
    if args.state.player[:alive] && 1500 > (args.state.player[:x] - enemy[:x]) ** 2 + (args.state.player[:y] - enemy[:y]) ** 2
      args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
      args.state.explosions << {x: args.state.player[:x] + 4, y: args.state.player[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
      args.state.player[:alive] = false
      true
    else
      false
    end
  end
  args.state.enemies_medium_center = args.state.enemies_medium_center.reject do |enemy|
    if args.state.player[:alive] && 1500 > (args.state.player[:x] - enemy[:x]) ** 2 + (args.state.player[:y] - enemy[:y]) ** 2
      args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
      args.state.explosions << {x: args.state.player[:x] + 4, y: args.state.player[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
      args.state.player[:alive] = false
      true
    else
      false
    end
  end

  #Enemy bullet collision detection.
  args.state.enemy_bullets.each do |bullet|
    if args.state.player[:alive]
      if bullet.intersect_rect? args.state.player
        args.state.explosions << {x: args.state.player[:x] + 4, y: args.state.player[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
        args.state.player[:alive] = false
        bullet[:despawn]          = true
      end
    end
  end

  #Player bullet collision detection.
  args.state.enemies_small_left = args.state.enemies_small_left.reject do |enemy|
    args.state.player_bullets_1.any? do |bullet|
      if bullet.intersect_rect? enemy
        enemy[:health] -= 10
        bullet[:despawn] = true
        args.state.explosions_small << {x: bullet[:x] + 4, y: bullet[:y] + 4, w: 8, h: 8, path: 'sprites/explosion-small-0.png', age: 0}
        if enemy[:health] <= 0
          args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
          args.state.score += 100
          true
        end
      else
        false
      end
    end
  end
  args.state.enemies_small_left = args.state.enemies_small_left.reject do |enemy|
    args.state.player_bullets_2.any? do |bullet|
      if bullet.intersect_rect? enemy
        enemy[:health] -= 10
        bullet[:despawn] = true
        args.state.explosions_small << {x: bullet[:x] + 4, y: bullet[:y] + 4, w: 8, h: 8, path: 'sprites/explosion-small-0.png', age: 0}
        if enemy[:health] <= 0
          args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
          args.state.score += 100
          true
        end
      else
        false
      end
    end
  end
  args.state.enemies_small_right = args.state.enemies_small_right.reject do |enemy|
    args.state.player_bullets_1.any? do |bullet|
      if bullet.intersect_rect? enemy
        enemy[:health] -= 10
        bullet[:despawn] = true
        args.state.explosions_small << {x: bullet[:x] + 4, y: bullet[:y] + 4, w: 8, h: 8, path: 'sprites/explosion-small-0.png', age: 0}
        if enemy[:health] <= 0
          args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
          bullet[:despawn] = true
          args.state.score += 100
          true
        end
      else
        false
      end
    end
  end
  args.state.enemies_small_right = args.state.enemies_small_right.reject do |enemy|
    args.state.player_bullets_2.any? do |bullet|
      if bullet.intersect_rect? enemy
        enemy[:health] -= 10
        bullet[:despawn] = true
        args.state.explosions_small << {x: bullet[:x] + 4, y: bullet[:y] + 4, w: 8, h: 8, path: 'sprites/explosion-small-0.png', age: 0}
        if enemy[:health] <= 0
          args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
          bullet[:despawn] = true
          args.state.score += 100
          true
        end
      else
        false
      end
    end
  end
  args.state.enemies_medium_center = args.state.enemies_medium_center.reject do |enemy|
    args.state.player_bullets_1.any? do |bullet|
      if bullet.intersect_rect? enemy
        enemy[:health] -= 10
        bullet[:despawn] = true
        args.state.explosions_small << {x: bullet[:x] + 4, y: bullet[:y] + 4, w: 8, h: 8, path: 'sprites/explosion-small-0.png', age: 0}
        if enemy[:health] <= 0
          args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
          args.state.score += 100
          true
        end
      else
        false
      end
    end
  end
  args.state.enemies_medium_center = args.state.enemies_medium_center.reject do |enemy|
    args.state.player_bullets_2.any? do |bullet|
      if bullet.intersect_rect? enemy
        enemy[:health] -= 10
        bullet[:despawn] = true
        args.state.explosions_small << {x: bullet[:x] + 4, y: bullet[:y] + 4, w: 8, h: 8, path: 'sprites/explosion-small-0.png', age: 0}
        if enemy[:health] <= 0
          args.state.explosions << {x: enemy[:x] + 4, y: enemy[:y] + 4, w: 32, h: 32, path: 'sprites/explosion-0.png', age: 0}
          args.state.score += 100
          true
        end
      else
        false
      end
    end
  end

  args.state.player_bullets_1 = args.state.player_bullets_1.reject { |bullet| bullet[:despawn] }
  args.state.player_bullets_2 = args.state.player_bullets_2.reject { |bullet| bullet[:despawn] }
  args.state.enemy_bullets  = args.state.enemy_bullets.reject { |bullet| bullet[:despawn] }

  args.state.player[:cooldown] -= 1
  if args.inputs.keyboard.key_held.space && args.state.player[:cooldown] <= 0 && args.state.player[:alive]
    args.state.player_bullets_1 << {x: args.state.player[:x] + 16, y: args.state.player[:y] + 38, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: 8}.sprite!
    args.state.player_bullets_2 << {x: args.state.player[:x] + 32, y: args.state.player[:y] + 38, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: 8}.sprite!
    args.state.player[:cooldown] = 10 + 1
  end
  args.state.enemies_small_left.each do |enemy|
    if Math.rand < 0.004 + 0.004 && args.state.player[:alive]
      args.state.enemy_bullets << {x: enemy[:x] + 12, y: enemy[:y] - 8, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: -3}.sprite!
    end
  end
  args.state.enemies_small_right.each do |enemy|
    if Math.rand < 0.004 + 0.004 && args.state.player[:alive]
      args.state.enemy_bullets << {x: enemy[:x] + 12, y: enemy[:y] - 8, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: -3}.sprite!
    end
  end
  args.state.enemies_medium_center.each do |enemy|
    if Math.rand < 0.006 + 0.006 && args.state.player[:alive]
      args.state.enemy_bullets << {x: enemy[:x] + 21, y: enemy[:y] - 8, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: -3}.sprite!
      args.state.enemy_bullets << {x: enemy[:x] + 48, y: enemy[:y] - 8, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: -3}.sprite!
      args.state.enemy_bullets << {x: enemy[:x] + 63, y: enemy[:y] - 8, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: -3}.sprite!
      args.state.enemy_bullets << {x: enemy[:x] + 90, y: enemy[:y] - 8, w: 6, h: 13, path: 'sprites/bullet1.png', dx: 0, dy: -3}.sprite!
    end
  end

  args.outputs.background_color = [0, 0, 0]
  args.outputs.primitives << args.state.enemies_small_left.map do |enemy|
    [enemy[:x], enemy[:y], 32, 32, enemy[:path], -180].sprite
  end
  args.outputs.primitives << args.state.enemies_small_right.map do |enemy|
    [enemy[:x], enemy[:y], 32, 32, enemy[:path], -180].sprite
  end
  args.outputs.primitives << args.state.enemies_medium_center.map do |enemy|
    [enemy[:x], enemy[:y], 128, 24, enemy[:path], -0].sprite
  end
  args.outputs.primitives << args.state.player if args.state.player[:alive]
  args.outputs.primitives << args.state.explosions
  args.outputs.primitives << args.state.explosions_small
  args.outputs.primitives << args.state.player_bullets_1
  args.outputs.primitives << args.state.player_bullets_2
  args.outputs.primitives << args.state.enemy_bullets
  args.outputs.primitives << [
    [0, 0, 300, 720, 0, 0, 100].solid,
    [1280 - 300, 0, 300, 720, 0, 0, 100].solid,
    [1280 - 290, 20, "Score    #{(args.state.score).floor}", 255, 255, 255].label,
    [50, 700, "Time    #{(args.state.time_seconds)}", 5, 255, 255, 255, 255].label,
  ]
  #args.outputs.debug << args.gtk.framerate_diagnostics_primitives

  #Respawn player if player dies.
  if (!args.state.player[:alive]) && args.state.enemy_bullets.empty? && args.state.explosions.empty? && args.state.enemies_small_left.all? && args.state.enemies_small_right.all?
    #args.state.player[:alive] = true
    args.state.player[:x]     = 624
    args.state.player[:y]     = 80
    #args.state.clear!
    args.state.next_scene = :game_over_scene
  end
end

def tick_game_over_scene args
  args.state.player[:alive] = false
  args.outputs.background_color = [0, 0, 0]
  args.outputs.labels << [560, 500, "Times up!", 10, 255, 255, 255, 255]
  args.outputs.labels << [460, 450, "Final score: #{(args.state.score)}", 10, 255, 255, 255, 255]
  args.outputs.labels << [320, 400, "Press the Enter key to try again.", 10, 255, 255, 255, 255]
  if args.inputs.keyboard.enter
    args.state.next_scene = :game_scene
    args.state.player[:alive] = true
    args.state.explosions.clear
    args.state.enemies_small_left.clear
    args.state.enemies_small_right.clear
    args.state.enemies_medium_center.clear
    args.state.enemy_bullets.clear
    args.state.score = 0
    args.state.time_seconds = 20
    args.state.player_bullets_1.clear
    args.state.player_bullets_2.clear
  end
end