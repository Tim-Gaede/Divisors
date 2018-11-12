using Formatting

#=
This uses divisor candidates from 2 to one less than
the square-root of the passed number.  If the passed number is
divisible by this divisor candidate, a pair of divisors is generated
(the candidate divisor and the quotient) and each member is pushed
into separate arrays.  If the passed number is a perfect square, 
a final divisor is added to the first array, otherwise each member of
a final divsor pair may be added to each array.

All elements in the array of quotients are pushed into the other
array in reverse order to ensure the final returned array is sorted.
=#
function divisors(num::Int)
    if num <= 0
        msg = "** divisors() was passed " * string(num) * " **"
        throw(DomainError(msg))
    end

    if num == 1    return [1]  end
    if num <= 3    return[1, num]  end

    divs = Int64[1];    divsLarge = Int64[num]

    root = convert( Int64, floor(√num + 0.5) )
    for cand_divisor = 2 : root -1
        if num % cand_divisor == 0
            push!(divs, cand_divisor)
            push!( divsLarge, div(num, cand_divisor) )
        end
    end

    if num % root == 0
        push!(divs, root)

        if root^2 != num
            push!( divsLarge, div(num, root^2) )
        end
    end

    for i = length(divsLarge) : -1 : 1
        push!(divs, divsLarge[i])
    end


    divs
end


#=
     If the number (the original passed number or the number that remains)
is divisible by a prime less than or equal to the square-root of the
original number, then the number is continually divided by the prime
until it is no longer divisible.  This procedure generates the exponent
of the particular prime factor.

     From the prime factors and their exponents, all divisors are generated.
For example, the prime factorization of the number, 25920 is:

(2^6) × (3^4)  × (5^1)

Each divisor's prime factorization has a unique combination of exponents.
The exponent ranges are:
(0 to 6), (0 to 4), (0 to 1)

Therefore, the number of divisors is
(7) × (5) × (2) = 70
A code whose values range from 0 to 69 is used to generate a unique combination
of exponents and therefore a unique divisor.
=#
function divisors(num::Int, primes)
    if num <= 0
        msg = "** divisors(,) was passed " * string(num) * " **"
        throw(DomainError(msg))
    end

    if num == 1    return [1]  end
    if num <= 3    return [1, num]  end

    factors = [];    powers = []

    root = convert( Int64, floor(√num + 0.5) )
    if root >= last(primes)    primes = primesTo(2root)  end

    # Break down the number into its prime factors and exponents ---------------
    i = 1;    rem = num # remaining
    while rem != 1    &&    primes[i] <= root
        if rem % primes[i] == 0
            push!(factors, primes[i])
            power = 0
            while rem % primes[i] == 0
                rem = div(rem, primes[i])
                power += 1
            end
            push!(powers, power)

        end
        i += 1
    end

    if rem != 1
        push!(factors, rem)
        push!(powers, 1)
    end
    # --------------------------------------------------------------------------



    # Use the factors and powers to generate all divisors ----------------------
    divs = []
    numDivs = Int64(1)
    for item in powers    numDivs *= item+1  end

    codeMax = numDivs - 1
    for code = 0 : codeMax
        rem = code
        divisor = Int64(1)
        i = 1

        while rem > 0
            expo = rem % (powers[i] + 1)
            divisor *= factors[i]^expo
            rem = div( rem, (powers[i] + 1) )
            i += 1
        end

        push!(divs, divisor)
    end
    # --------------------------------------------------------------------------

    sort(divs)
end




function primesTo(cand_max) # (candidate_max)

    primes = Int64[2]
    eliminated = falses(cand_max)

    sqrtCandMax = convert( Int64, floor(√cand_max + 0.5) )
    for divisor = 3 : 2 : sqrtCandMax
        if !eliminated[divisor]
            for i = 3divisor : 2divisor : cand_max
                eliminated[i] = true
            end
        end
    end


    for n = 3 : 2 : cand_max
        if !eliminated[n]    push!(primes, n)  end
    end


    primes
end




function fibonaccis(max)
    result = Int64[1, 1]
    maxReached = false

    while !maxReached
        next = last(result) + result[length(result) - 1]

        if next <= max    push!(result, next)
        else              maxReached = true
        end
    end


    result
end




function main()

    primeLimit = 10^9
    println("Generating Primes...")
    primes = primesTo(primeLimit)

    fibs = fibonaccis(primeLimit^2)

    for item in fibs
        println( format(item, commas = true) )
        @time divsOld = divisors(item)
        @time divsNew = divisors(item, primes)
        println("Same array?: ", divsOld == divsNew)
        println("Num divisors = ", length(divsOld), ", ", length(divsNew))
        println("\r\n"^3)
    end

    println("\r\n"^2, "Done!")
end
main()
