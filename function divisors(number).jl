using Formatting

function divisors(number)

    divs = Int64[]

    push!(divs, 1)
    if (number == 1)    return divs  end

    if (number <= 3)
        push!(divs, number)
        return divs
    end

    divsLarge = Int64[]
    push!(divsLarge, number)



    sqrt_rounded = convert( Int64, floor(√number + 0.5) )
    for candidate_divisor = 2 : sqrt_rounded -1
        if number % candidate_divisor == 0
            push!(divs, candidate_divisor)
            push!( divsLarge, div(number, candidate_divisor) )
        end
    end

    if number % sqrt_rounded == 0
        push!(divs, sqrt_rounded)

        if sqrt_rounded^2 != number
            push!( divsLarge, div(number, sqrt_rounded^2) )
        end
    end

    for i = length(divsLarge) : -1 : 1
        push!(divs, divsLarge[i])
    end


    return divs
end


function divisors(number, primes)

    # Generate prime factors and their exponents--------------------------------
    factors = Int64[]
    powers = Int64[]

    root = convert( Int64, floor(√number + 0.5) )
    if root >= last(primes)
        primes = primesUpTo(2root)
    end


    remaining = number
    index = 1
    while remaining != 1    &&    primes[index] <= root
        if remaining % primes[index] == 0
            push!(factors, primes[index])
            power = 0
            while remaining % primes[index] == 0
                remaining = div(remaining, primes[index])
                power += 1
            end
            push!(powers, power)
        end
        index += 1
    end

    if remaining > 1
        push!(factors, remaining)
        push!(powers, 1)
    end
    # --------------------------------------------------------------------------



    # Use the factors and powers to generate all divisors ----------------------
    result = Int64[]
    numDivisors = Int64(1)
    for item in powers
        numDivisors *= (item + 1)
    end

    codeMax = numDivisors - 1
    for code = 0 : codeMax
        remaining = code
        divisor = Int64(1)
        index = 1

        while remaining > 0
            exponent = remaining % (powers[index] + 1)
            divisor *= factors[index]^exponent
            remaining = div( remaining, (powers[index] + 1) )
            index += 1
        end

        push!(result, divisor)
    end
    # --------------------------------------------------------------------------


    return sort(result)
end


function primesUpTo(candidate_max)
# Modified Sieve of Eratosthenes (era-TOSS-the-knees)
    primes = Int64[]
    push!(primes, 2) # The number two is prime

    # Create an array of booleans to indicate whether a number
    # (as indicated by the index) has been eliminated as a prime.
    eliminated = falses(candidate_max)

    # Eliminate all multiples of non-eliminated odd numbers
    # (except for that number itself)
    sqrtCandidateMax = convert( Int64, floor(√candidate_max + 0.5) )
    for divisor = 3 : 2 : sqrtCandidateMax
        if !eliminated[divisor]
            for i = 2divisor : divisor : candidate_max
                eliminated[i] = true
            end
        end
    end

    # All odd non-eliminated numbers are prime
    for i = 3 : 2 : candidate_max # Only check odd numbers for primality
        if !eliminated[i]
            push!(primes, i)
        end
    end



    return primes
end

function fibonaccis(max)
    result = Int64[1, 1]
    maxReached = false

    while !maxReached
        next = last(result) + result[length(result) - 1]
        if next <= max
            push!(result, next)
        else
            maxReached = true
        end
    end


    return result
end


function main()

    primeLimit = 10^9
    println("Generating Primes...")
    primes = primesUpTo(primeLimit)

    fibs = fibonaccis(primeLimit^2)

    for item in fibs
        println( format(item, commas = true) )
        @time divsOld = divisors(item)
        @time divsNew = divisors(item, primes)
        println("Num divisors = ", length(divsOld), ", ", length(divsNew))
        println("\r\n"^3)
    end

    println("\r\n"^2, "Done!")
end
main()
