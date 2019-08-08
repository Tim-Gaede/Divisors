

function divisors!(n::Int, primes::Array{Int,1})
# Returns an UNSORTED list of all factors
# Will extend the array of primes iff it is inadequate for factorization
    if n < 1    throw("n must be a positive integer.")  end
    if n == 1  return [1]  end

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


function divisors_2nd!(n::Int, primes::Array{Int,1})
# Returns an UNSORTED list of all factors
# Will extend the array of primes iff it is inadequate for factorization
    if n < 1    throw("n must be a positive integer.")  end
    if n == 1  return [1]  end

    factors = []
    powers = []


    root = convert(Int64, floor(√n + 0.5))
    if root ≥ last(primes)
        primesNew = primesUpTo(2root)
        len = length(primes)
        for i = len + 1 : length(primesNew)
            push!(primes, primesNew[i])
        end
    end

    rem = n
    i = 1
    while rem ≠ 1    &&    primes[i] ≤ rem
        if rem % primes[i] == 0

            push!(factors, primes[i])
            power = 0
            while rem % primes[i] == 0
                rem ÷= primes[i]
                power += 1
            end
            push!(powers, power)
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






function primesUpTo(limit::Integer)
    if limit < 2    return []  end
    primes = Int64[2]
    πLim = convert( Int64, floor( limit / log(limit) ) )
    sizehint!(primes, πLim)
    oddsElim = falses((limit-1) ÷ 2) # odd numbers greater than 2
    i_max =  (convert(Int64, floor(√limit))-1) ÷ 2

    for i = 1 : i_max
        if !oddsElim[i]
            n = 2i + 1
            for ĩ = i + n : n : length(oddsElim)
                oddsElim[ĩ] = true
            end
        end
    end

    for i = 1 : length(oddsElim)
        if !oddsElim[i]    push!(primes, 2i + 1)  end
    end

    primes
end


