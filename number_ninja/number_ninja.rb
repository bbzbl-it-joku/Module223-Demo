class NumberNinja
  def initialize
    @level = 0
    @guesses = 0
    @points = 0
    @timetrack = false
    @t = nil
  end

  # Display a welcome message
  # @return [void]
  def hello
    puts "Willkommen bei NumberNinja!"

    if File.exist?("data/highscore.txt")
      puts "Alter Highscore gefunden!"
      puts "Möchtest du weitermachen? (j/n): "
      continue = gets.chomp
      if continue == "n"
        newGame
        File.delete("data/highscore.txt")
      else
        loadHighscore
      end
    else
      newGame
    end
  end

  # Load the highscore from a file
  # @return [void]
  def loadHighscore
    File.open("data/highscore.txt", "r") do |file|
      file.each_line do |line|
        file_data = line.split(";")
        @level = file_data[1].to_i
        @timetrack = file_data[2] == "true"
        @points = file_data[3].to_i
      end
    end
    File.delete("data/highscore.txt")
    puts "Alter Highscore geladen!"
    play
  end

  # Start a new game
  # @return [void]
  def newGame
    puts "Neues Spiel starten!"
    print "Wähle eine Schwierigkeitsstufe: (1) Leicht 0-50, (2) Mittel 0-100, (3) Schwer 0-200: \n"
    difficulty = gets.chomp.to_i
    print "Zeitlimit (30s) aktivieren? (j/n): "
    timetrack = gets.chomp.to_s
    @timetrack = (timetrack == "j")

    case difficulty
    when 1
      @level = 1
      play
    when 2
      @level = 2
      play
    when 3
      @level = 3
      play
    else
      puts "Fehlerhafte Eingabe: Schwierigkeitsstufe nicht erkannt."
    end
  end

  # Play the game
  # @return [void]
  def play
    case @level
    when 1
      maxnum = 50
    when 2
      maxnum = 100
    when 3
      maxnum = 200
    end

    puts "Errate die Zahl zwischen 0 und " + maxnum.to_s + "!"
    @secret_number = rand(0..maxnum)

    if @timetrack
      @start_time = Time.now
      puts "Du hast 30 Sekunden Zeit!"
      @t = Thread.new do
        sleep 30
        puts "\n\nZeit abgelaufen!"
        play_again
      end
    end

    loop do
      print "Gib deine Vermutung ein: "
      guess = gets.chomp.to_i
      @guesses += 1

      if validate(guess, maxnum)
        if guess == @secret_number
          @t.kill if @timetrack && @t
          win
          break
        elsif guess < @secret_number
          puts "Zu niedrig! Versuche es nochmal."
        else
          puts "Zu hoch! Versuche es nochmal."
        end
      end
    end
  end

  # Validate the guess
  # @return [Boolean]
  def validate(guess, maxnum)
    if guess >= 0 && guess <= maxnum
      true
    else
      puts "Fehlerhafte Eingabe: Zahl nicht zwischen 0 und " + maxnum.to_s + "."
      false
    end
  end

  # Display a win message
  # @return [void]
  def win
    puts "Glückwunsch! Du hast die Zahl erraten!"
    puts "Du hast " + @guesses.to_s + " Versuche gebraucht!"

    if @guesses == 1
      @points += 1000
      puts "Perfekt! Du erhältst 1000 Punkte!"
    elsif @guesses < 5
      @points += 500
      puts "Schnell geraten! Du erhältst 500 Punkte!"
    elsif @guesses < 10
      @points += 200
      puts "Gut gemacht! Du erhältst 200 Punkte!"
    elsif @guesses < 15
      @points += 100
      puts "Nicht schlecht! Du erhältst 100 Punkte!"
    else
      puts "Du erhältst keine Punkte."
    end
    puts "\nDeine Punktzahl: " + @points.to_s + "\n"

    play_again
  end

  # Prompt for replay
  # @return [void]
  def play_again
    print "Nochmal spielen? (j/n): "
    play_again = gets.chomp
    if play_again == "j"
      @guesses = 0
      play
    else
      endRound
    end
  end

  # End the round
  # @return [void]
  def endRound
    print "Möchtest du deinen Highscore speichern? (j/n): "
    save = gets.chomp
    if save == "j"
      saveHighscore
    else
      puts "Auf Wiedersehen!"
    end
  end

  # Save the highscore to a file
  # @return [void]
  def saveHighscore
    Dir.mkdir("data") unless File.exist?("data")
    File.delete("data/highscore.txt") if File.exist?("data/highscore.txt")

    File.open("data/highscore.txt", "w") do |file|
      file.write(Time.now.strftime("%Y-%m-%d %H:%M:%S") + ";")
      file.write(@level.to_s + ";")
      file.write(@timetrack.to_s + ";")
      file.write(@points.to_s)
    end
    puts "Highscore gespeichert! Auf Wiedersehen!"
  end
end

game = NumberNinja.new
game.hello
