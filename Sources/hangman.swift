// The Swift Programming Language
// https://docs.swift.org/swift-book

import Darwin


class Hangman {
    let wordlist = ["banan", "citron", "plommon", "persika", "äpple"]
    let hiddenChar = "_"

    var secretWord: String 
    var secretWordLen: Int
    var guessesLeft: Int = 10
    var numberOfCorrectGuesses: Int = 0
    var guesses: String = ""
    var correctGuesses = 0

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
        // var gotInput = false  // 

        // while !gotInput {
        while guessedChar.isEmpty {
            print("Make a guess: ", terminator: "")
            if let input = readLine(strippingNewline: true) {
                guard input != "quit" else {
                    gameStatus = .quitting
                    break
                }
                guard !input.isEmpty else {
                    continue
                }
                guessedChar = String(input[input.startIndex])
                // guessedChar = input[input.startIndex]
                print("guessedChar: \(guessedChar)")
                // gotInput = true
            } 
        }

        let index = guesses.firstIndex(of: Character(guessedChar)) ?? nil
        if index == nil {
            guesses.append(guessedChar.lowercased())
            guessesLeft -= 1
        }

    }


    func checkGameStatus() {
        print("guessed characters: ", terminator: "")
        for c in guesses {
            print("\(c) ", terminator: "")
        }
        print()

        correctGuesses = 0
        for character in secretWord {
            if guesses.firstIndex(of: character) != nil {
                print("\(character) ", terminator:"")
                correctGuesses += 1
            } else {
                print("_ ", terminator: "")
            }
        }
        print()
        print("number of guesses left: \(guessesLeft)")
        print("correct guesses: \(correctGuesses)")
        if correctGuesses == secretWord.count {
            gameStatus = .winning
            doExitGame(gameStatus) 
        }
        print()
    }


    func doExitGame(_ status: Status = .quitting) {
        if status == .winning {
            print()
            print("Congratulations, you won!")
            print("The secret word was \(secretWord)")
        } else if status == .playing && guessesLeft <= 0 {
            print("Game over")
        } else  if status == .quitting {
            print("Bye!")
        }
        exit(0)
    }


    func gameLoop() {
        while guessesLeft > 0 {
            makeGuess()
            checkGameStatus()
        }
        doExitGame()
    }
}

guard let hangman = Hangman() else {
    print("Failed to create game")
    exit(-1)
}


print("secretWord: \(hangman.secretWord)")
hangman.gameLoop()
