class NumberNinja
  def initialize
    @level = 0
    @guesses = 0
    @points = 0
  end

  # Display a welcome message
  # @return [void]
  # DONE
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
  # DONE
  def loadHighscore
    File.open("data/highscore.txt", "r") do |file|
      file.each_line do |line|
        file_data = line.split(";")
        @level = file_data[1].to_i
        @points = file_data[2].to_i
      end
    end
    File.delete("data/highscore.txt")
    puts "Alter Highscore geladen!"
    play
  end

  # Start a new game
  # @return [void]
  # DONE
  def newGame
    puts "Neues Spiel starten!"
    print "Wähle eine Schwierigkeitsstufe: (1) Leicht 0-50, (2) Mittel 0-100, (3) Schwer 0-200: \n"
    difficulty = gets.chomp.to_i
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
  # DONE
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

    loop do
      print "Gib deine Vermutung ein: "
      guess = gets.chomp.to_i
      @guesses = @guesses + 1

      if validate(guess, maxnum)
        if guess == @secret_number
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

  # Start the game
  # @return [void]
  # DONE
  def validate(guess, maxnum)
    if guess >= 0 && guess <= maxnum
      return true
    else
      puts "Felerhafte Eingabe: Zahl nicht zwischen 0 und " + maxnum.to_s + "."
      return false
    end
  end

  # Display a win message
  # @return [void]
  # DONE
  def win
    puts "Glückwunsch! Du hast die Zahl erraten!"
    puts "Du hast " + @guesses.to_s + " Versuche gebraucht!"

    if @guesses == 1
      @points = @points + 1000
      puts "Perfekt! Du erhältst 1000 Punkte!"
    elsif @guesses < 5
      @points = @points + 500
      puts "Schnell geraten! Du erhältst 500 Punkte!"
    elsif @guesses < 10
      @points = @points + 200
      puts "Gut gemacht! Du erhältst 200 Punkte!"
    elsif @guesses < 15
      @points = @points + 100
      puts "Nicht schlecht! Du erhältst 100 Punkte!"
    else
      puts "Du erhältst keine Punkte."
    end
    print "\n Deine Punktzahl: " + @points.to_s + "\n"

    print "Nochmal spielen? (j/n): "
    play_again = gets.chomp
    if play_again == "j"
      @guesses = 0
      start
    else
      endRound
    end
  end

  # End the round
  # @return [void]
  # DONE
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
  # DONE
  def saveHighscore
    if !File.exist?("data")
      Dir.mkdir("data")
    end
    if File.exist?("data/highscore.txt")
      File.delete("data/highscore.txt")
    end
    File.open("data/highscore.txt", "w") do |file|
      file.write(Time.now.strftime("%Y-%m-%d %H:%M:%S"))
      file.write(";")
      file.write(@level)
      file.write(";")
      file.write(@points)
    end
    puts "Auf Wiedersehen!"
  end
end

game = NumberNinja.new
game.hello
