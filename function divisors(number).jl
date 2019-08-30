# Timothy Gaede
# TimGaede@gmail.com
#───────────────────────────────────────────────────────────────────────────────
function divisors!(n::Int, primes::Array{Int,1})
# Returns an UNSORTED list of all factors
# Will extend the array of primes iff it is inadequate for factorization
    if n  < 1;    throw("n must be greater than zero."); end
    if n == 1;    return [1]; end

    factors = []
    powers = []


    sqrt_n = convert(Int64, floor(√n + 0.5))
    if sqrt_n ≥ last(primes)
        primesNew = primesUpTo(2sqrt_n)
        len = length(primes)
        for i = len + 1 : length(primesNew)
            push!(primes, primesNew[i])
        end
    end

    rem = n
    root = convert(Int64, floor(√rem + 0.5))
    i = 1
    while rem ≠ 1    &&    primes[i] ≤ root
        if rem % primes[i] == 0

            push!(factors, primes[i])
            power = 0
            while rem % primes[i] == 0
                rem ÷= primes[i]
                power += 1
            end
            push!(powers, power)
            root = convert(Int64, floor(√rem + 0.5))
        end
        i += 1
    end
    if rem ≠ 1
        push!(factors, rem)
        push!(powers, 1)
    end

    # Use the factors and powers to generate all divisors
    result = []
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
#-------------------------------------------------------------------------------

#───────────────────────────────────────────────────────────────────────────────
function primesUpTo(lim::Integer)
    if lim < 2;    return []; end
    primes = Int64[2]
    sizehint!(primes, convert( Int64, floor( lim / log(lim) ) ))
    oddsAlive = trues((lim-1) ÷ 2) # oddsAlive[i] represents 2i + 1

    i_sqrt = (convert( Int64, floor(√lim) ) - 1) ÷ 2
    for i = 1 : i_sqrt
        if oddsAlive[i] # It's prime.  Kill odd multiples of it
            push!(primes, 2i + 1)
            Δᵢ = 2i + 1
            for iₓ = i+Δᵢ : Δᵢ : length(oddsAlive);   oddsAlive[iₓ] = false; end
        end
    end
    for i = i_sqrt + 1 : length(oddsAlive) # Remaining living odds also prime
        if oddsAlive[i];    push!(primes, 2i + 1); end
    end

    primes
end

#───────────────────────────────────────────────────────────────────────────────

#-------------------------------------------------------------------------------
function totalNumDivs!(min, max, primes)
    result = 0
    for num = min : max
        result += length(divisors!(num, primes))
    end

    result
end
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
function totalNumDivs(min, max)
    result = 0
    for num = min : max
        result += length(divisors(num))
    end

    result
end
#-------------------------------------------------------------------------------

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
