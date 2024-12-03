// The Swift Programming Language
// https://docs.swift.org/swift-book

import Darwin


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
        var guessedChar: String = ""
        while guessedChar.isEmpty {
            print("Make a guess: ", terminator: "")
            if let input = readLine(strippingNewline: true) {
                guard input != "quit" else {
                    // User type "quit": set gameStatus to .quitting
                    gameStatus = .quitting
                    print("quitting")
                    return 
                }
                guard !input.isEmpty else {
                    continue
                }
                guessedChar = String(input[input.startIndex])
            } 
        }

        // Add the guessed character only if it's not been already guessed 
        let index = guesses.firstIndex(of: Character(guessedChar.lowercased())) ?? nil  // returns nil if not found
        if index == nil {
            guesses.append(guessedChar.lowercased())
            guessesLeft -= 1
        }

    }


    // checkGameStatus: Prints stuff
    func checkGameStatus() {

        if gameStatus == .quitting { doExitGame(Status.quitting) }

        func printGuessed() {
            // print already guessed characters
            print("Guessed characters: ", terminator: "")
            for c in guesses {
                print("\(c) ", terminator: "")
            }
            print()
        }

        printGuessed()

        // Count # of correct guesses, print those and print a "_" for 
        // the rest of the (not guessed) characters.
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

        // check if the secret word has been corretly guessed and set 
        // gameStatus accordingly
        if correctGuesses == secretWord.count {
            // gameStatus = .winning
            // doExitGame(gameStatus) 
            doExitGame(Status.winning)
        }

        print("Number of guesses left: \(guessesLeft)")
        // print("correct guesses: \(correctGuesses)")
        print()
    }


    // doExitGame(): Called when number of guesses have run out,
    // if the user types "quit", or if the secret word has been
    // correctly guessed (status set to 'winning')
    func doExitGame(_ status: Status = .quitting) {
        if status == .winning {
            print()
            print("Congratulations, you won!")
            print("The secret word was \(secretWord)")
        } else if status == .losing {
            print("Game over")
        } else  if status == .quitting {
            print("Bye!")
        }
        exit(0)
    }


    // gameLoop(): Repeatedly ask user to make a guess until
    // the number of guesses run out or the word is guessed.
    func gameLoop() {
        while guessesLeft > 0 {
            makeGuess()
            checkGameStatus()
        }
        doExitGame(Status.losing)
    }
}

guard let hangman = Hangman() else {
    print("Failed to create game")
    exit(-1)
}


print("secretWord: \(hangman.secretWord)")
hangman.gameLoop()
