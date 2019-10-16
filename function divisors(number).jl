#───────────────────────────────────────────────────────────────────────────────
function divisors!(n::Int, primes::Array{Int,1})
    # Returns a sorted list of all divisors of n.
    # Will extend the array of primes if possibly inadequate for factorization
        if n  < 1;    throw(DomainError("n must be greater than zero."));    end
        if n == 1;    return []; end


        fctrs_pwrs = []

        # Extend the array of primes if it may be inadequate
        sqrt_n_up = convert(Int64, ceil(√n))
        if length(primes) ==  0  ||  sqrt_n_up > last(primes)
            primes′ = primesTo(2sqrt_n_up)
            for i = length(primes) + 1 : length(primes′)
                push!(primes, primes′[i])
            end
        end

        rem = n
        sqrt_rem_down = convert(Int64, floor(√rem))
        i = 1
        while rem ≠ 1  &&  primes[i] ≤ sqrt_rem_down
            if rem % primes[i] == 0
                rem ÷= primes[i]
                pwr = 1
                while rem % primes[i] == 0
                    rem ÷= primes[i]
                    pwr += 1
                end
                push!(fctrs_pwrs, [primes[i], pwr])
            end
            sqrt_rem_down = convert(Int64, floor(√rem)) # Speed up or slow down?
            i += 1
        end

        if rem ≠ 1;    push!(fctrs_pwrs, [rem, 1]);    end



    # Use the factors and pwrs to generate all divisors
    numDvrs = Int64(1)
    for pair in fctrs_pwrs
        numDvrs *= (pair[2] + 1)
    end

    res = Int64[1] # 1 is always a divisor
    codeMax = numDvrs - 2
    for code = 1 : codeMax

        # Treat "code" as a mixed base number
        # whose number of digits is the
        # number of prime factors.
        # The base of each digit is the
        # corresponding prime factor's
        # power plus one.
        rem = code
        dvr = Int64(1)
        i = 1

        while rem > 0
            pwr = rem % (fctrs_pwrs[i][2] + 1)
            dvr *= fctrs_pwrs[i][1]^pwr
            rem ÷= (fctrs_pwrs[i][2] + 1)
            i += 1
        end

        push!(res, dvr)
    end
    push!(res, n) # n is always a divisor


    sort(res) #<≡≡≡≡≡≡≡≡ Modify if you don't need the divisors sorted !!!!!!!!!!
end
#───────────────────────────────────────────────────────────────────────────────


#-------------------------------------------------------------------------------
# Implementation of the Sieve of Eratosthenes where we take advantage of
# the option to iterate a for loop by more than 1.  Multiplying two numbers to
# get an odd would imply that both of those numbers were also odd.
function primesTo(n::Integer)
    if n < 2;    return []; end
    primes = Int64[2]
    sizehint!(primes, convert( Int64, floor( n / log(n) ) ))
    oddsAlive = trues((n-1) ÷ 2) # oddsAlive[i] represents 2i + 1

    i_sqrt = (convert( Int64, floor(√n) ) - 1) ÷ 2
    for i = 1 : i_sqrt
        if oddsAlive[i] # It's prime.  Kill odd multiples of it
            push!(primes, 2i + 1)
            Δᵢ = 2i + 1
            for iₓ = i+Δᵢ : Δᵢ : length(oddsAlive);   oddsAlive[iₓ] = false; end
        end
    end
    for i = i_sqrt + 1 : length(oddsAlive) # Surviving odds also prime
        if oddsAlive[i];    push!(primes, 2i + 1); end
    end

    primes
end
#-------------------------------------------------------------------------------


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function main()
    println("\n", "-"^40, "\n"^2)
    N = 5040
    primes = Int[]
    println("Initial list of primes:\n\n$primes", "\n"^4)
    dvrs = divisors!(N, primes)
    println("There are ", length(dvrs), " divisors of $N:\n")
    println(dvrs, "\n"^4)
    println("Final list of primes:\n\n$primes")
end
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main()
