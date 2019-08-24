# Timothy Gaede
# TimGaede@gmail.com
#───────────────────────────────────────────────────────────────────────────────
function divisors!(n::Int, primes::Array{Int,1})
# Returns an UNSORTED list of all factors
# Will extend the array of primes iff it is inadequate for factorization
    if n < 1    throw("n must be a positive integer.")  end
    if n == 1  return [1]  end

    factors = Int64[]
    powers  = Int64[]


    sqrt_n = convert(Int64, floor(√n + 0.5))
    if sqrt_n ≥ last(primes)
        primesNew = primesUpTo(2sqrt_n)
        len = length(primes)
        for i = len + 1 : length(primesNew)
            push!(primes, primesNew[i])
        end
    end

    rem = n
    root_rem = convert(Int64, floor(√rem + 0.5))
    i = 1
    while rem ≠ 1    &&    primes[i] ≤ root_rem
        if rem % primes[i] == 0

            push!(factors, primes[i])
            power = 0
            while rem % primes[i] == 0
                rem ÷= primes[i]
                power += 1
            end
            push!(powers, power)
            root_rem = convert(Int64, floor(√rem + 0.5))
        end
        i += 1
    end
    if rem ≠ 1
        push!(factors, rem)
        push!(powers, 1)
    end

    # Use the factors and powers to generate all divisors
    result = Int64[]
    numDivisors = Int64(1)
    for item in powers
        numDivisors *= (item + 1)
    end

    codeMax = numDivisors - 1
    for code = 0 : codeMax
        rem = code
        divisor = Int64(1)
        i = 1

        while rem > 0
            exponent = rem % (powers[i] + 1)
            divisor *= factors[i]^exponent
            rem ÷= (powers[i] + 1)
            i += 1
        end

        push!(result, divisor)
    end



    result
end
#───────────────────────────────────────────────────────────────────────────────



#───────────────────────────────────────────────────────────────────────────────
function primesUpTo(limit::Integer)
    if limit < 2;    return []; end
    primes = Int64[2]

    # To possibly save time, use the prime counting function
    # to set the amount of memory to allocate.
    sizehint!(primes, convert( Int64, floor( limit / log(limit) ) ))

    # Keep track of all odd numbers greater than 1
    # that are still candidates for being prime.
    # oddsCandidates[index] represents the number, 2index + 1
    oddsCandidates = trues((limit-1) ÷ 2)

    # Iterate through the odd candidates up to the square root of the limit.
    # If that number is still a viable candidate then it must be prime
    # and its multiples must be eliminated as being prime.
    i_max = (convert( Int64, floor(√limit) ) - 1) ÷ 2
    for i = 1 : i_max
        if oddsCandidates[i]
            # The jumps in the index number must be an odd multiple
            # of the index of the newly discovered prime
            o = 2i + 1
            for j = i+o : o : length(oddsCandidates)
                oddsCandidates[j] = false
            end
        end
    end

    # Any odd number now that is still a candidate is prime.
    for i = 1 : length(oddsCandidates)
        if oddsCandidates[i];    push!(primes, 2i + 1); end
    end

    primes
end
#───────────────────────────────────────────────────────────────────────────────


#═══════════════════════════════════════════════════════════════════════════════
function main()
    println("\n\nGenerating primes\n")
    primes = primesUpTo(10^8)
    println("Primes generated.\n\n")
    println("\n"^6)
    n = rand(10^7 : last(primes))
    println("Divisors for $n:\n\n")
    divs_sorted = sort(divisors!(n, primes))
    num_figs = convert(Int64, floor(log10(last(divs_sorted)))) + 1
    for div in divs_sorted;    println(lpad(div, num_figs)); end
end
#═══════════════════════════════════════════════════════════════════════════════
main()
