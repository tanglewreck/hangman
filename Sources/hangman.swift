import Foundation

class Hangman {
    let wordlist = ["banan", "citron", "plommon", "persika", "äpple", "skurhink",
    "fasan", "hund", "katt", "gul", "röd", "orange", "grön"  ]

    let hiddenCharacter = "_"    // 
    var secretWord: String 
    var secretWordLen: Int
    var guessesLeft: Int = 10
    var numberOfCorrectGuesses: Int = 0
    var guesses: String = ""
    var correctGuesses = 0

    // Game status
    enum Status {
        case winning
        case quitting
        case losing
        case playing
    }
    var gameStatus = Status.playing

    init?() {
        guard wordlist.count > 0 else {
            return nil
        }
        secretWord = wordlist[Int.random(in: 0...wordlist.count - 1)]
        secretWordLen = secretWord.count
        assert(!secretWord.isEmpty, "secret word shouldn't be empty")

        // Make sure there's a secret word
        guard !secretWord.isEmpty else {
            print("secret word is empty")
            return nil
        } 

    }

    // makeGuess(): Prompt user for a guess and append the guess to 
    // guessed characters if it's not been guessed already.
    // If user inputs "quit", gameStatus is set to .quitting (this is
    // later caught in the gameLoop() function)
    func makeGuess() {
        // var guessedChar: String = ""
        var guess: String = ""

        // while guessedChar.isEmpty {
        while guess.isEmpty {
            print("Make a guess ('quit' to exit): ", terminator: "")

            if let input = readLine(strippingNewline: true) {
                guard input != "quit" else {
                    // User type "quit": set gameStatus to .quitting
                    gameStatus = .quitting
                    return 
                }
                // If input is empty, start over
                guard !input.isEmpty else {
                    continue
                }
                guess = input[input.startIndex].lowercased()
            } 
        }

        let guessChar = Character(guess)
        // Add the guessed character only if it's not been already guessed 
        if guesses.firstIndex(of: guessChar) ?? nil == nil {
            guesses.append(guessChar)
        }
        // Decrease number of guesses left by one if the 
        // guessed character isn't in the secret word
        if secretWord.firstIndex(of: guessChar) ?? nil == nil {
            guessesLeft -= 1
        }


    }


    // checkGameStatus: Prints stuff
    func checkGameStatus() {

        // printGuessed(): 
        // Count # of correct guesses, print those and print a "_" for 
        // the rest of the (not guessed) characters.
        func printGuessed() {
            // print already guessed characters
            print("Guessed characters: ", terminator: "")
            for c in guesses {
                print("\(c) ", terminator: "")
            }
        }

        // printWordLine():
        // Print a line with non-guessed characters
        // replaced by a "_"
        func printWordLine() {
            print()
            print("    ", terminator: "")
            correctGuesses = 0
            for character in secretWord {
                if guesses.firstIndex(of: character) != nil {  
                    // character found in the secret word, so print it
                    // and increment # of correctly guessed characters
                    print("\(character) ", terminator:"")  
                    correctGuesses += 1
                } else {
                    // character not found in the secret word:
                    // print a "_" character
                    print("\(hiddenCharacter) ", terminator: "")
                }
            }
            print()
            print("correctGuesses: \(correctGuesses)  (secretWord.count: \(secretWord.count))")
            if correctGuesses == secretWord.count { gameStatus = .winning }
            print()
        }

        if gameStatus == .quitting { doExitGame() }

        printWordLine()
        printGuessed()

        // check if the secret word has been corretly guessed and set 
        // gameStatus accordingly
        if correctGuesses == secretWord.count {
            // gameStatus = .winning
            // doExitGame(gameStatus) 
            gameStatus = .winning
            doExitGame()
        }

        print()
        print("Number of guesses left: \(guessesLeft)")
        // print("correct guesses: \(correctGuesses)")
        print()
    }


    // doExitGame(): Called when number of guesses have run out,
    // if the user types "quit", or if the secret word has been
    // correctly guessed (status set to 'winning')
    // func doExitGame(_ status: Status = .quitting) {
    func doExitGame() {
        if gameStatus == .playing { return }  // If still playing, just return
        if gameStatus == .winning {
            print()
            print("Congratulations, you won!")
        } else if gameStatus == .losing {
            print("Game over!")
        } else  if gameStatus == .quitting {
            print("Bye!")
        }
        print("The word was '\(secretWord)'")
        exit(0)
    }


    // gameLoop(): Repeatedly ask user to make a guess until
    // the number of guesses run out or the word is guessed.
    func gameLoop() {
        while gameStatus == .playing && guessesLeft > 0 {
            checkGameStatus()
            makeGuess()
        }
        gameStatus = .losing
        doExitGame()
    }
} // </class Hangman>


