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
    numDivisors = Int64(1)
    for item in powers
        numDivisors *= (item + 1)
    end

    result = Int64[1] # 1 is always a divisor
    codeMax = numDivisors - 2
    for code = 1 : codeMax
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
    push!(result, n) # n is always a divisor



    result
end
#───────────────────────────────────────────────────────────────────────────────

#-------------------------------------------------------------------------------
# This function is slower for large numbers but has pedagogical value
# as it is easier to understand.
function divisors(n::Int)    
    if n < 1;    throw("n must be an integer at least 1.") end;
    result = Int64[1]
    if n == 1;    return result; end

    sqrt_rounded_down = convert(Int64, floor(√n))
    div_cand_max = sqrt_rounded_down
    if sqrt_rounded_down^2 == n
        push!(result, sqrt_rounded_down);
        div_cand_max -= 1
    end

    for div_cand = 2 : div_cand_max
        if n % div_cand == 0
            push!(result, div_cand)
            push!(result, n ÷ div_cand)
        end
    end

    push!(result, n)

    result
end
#-------------------------------------------------------------------------------

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

function totalNumDivs!(min, max, primes)
    result = 0
    for num = min : max
        result += length(divisors!(num, primes))
    end

    result
end

function totalNumDivs(min, max)
    result = 0
    for num = min : max
        result += length(divisors(num))
    end

    result
end


#═══════════════════════════════════════════════════════════════════════════════
function main()
    println("\n", "─"^40, "\n")
    println("Generating primes\n")
    primes = primesUpTo(10^8)
    println("Primes generated.\n\n\n")

    n = rand(10^7 : last(primes))
    divs = sort(divisors!(n, primes))
    println("There are ", length(divs), " divisors for $n:\n\n")

    num_figs = convert(Int64, floor(log10(last(divs)))) + 1

    sort!(divs)
    for div in divs;    println(lpad(div, num_figs)); end

    num_min = 10_000_000
    num_max = num_min + 250_000
    println("\n\nTesting long function...")
    @time tot = totalNumDivs!(num_min, num_max, primes)
    println(tot, " total divisors for the long function...")
    println("\n\nTesting brute force function...")
    @time tot_brute = totalNumDivs(num_min, num_max)
    println(tot_brute, " total divisors for the brute force function.")
    println("\n"^3, "Done!")


end
#═══════════════════════════════════════════════════════════════════════════════
main()
