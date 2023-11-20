using CSV
using DataFrames
using GLMakie
using Colors
using Statistics
#using GR

f = Figure(resolution = (600, 900))
ax = f[1,1] = Axis(f, title = "Average", font = "Helvetica")
xlims!(ax, 0, 150)
ylims!(ax, 0, 1)
hidespines!(ax, :t, :r)
ax.xlabel = "Time (t)"
ax.ylabel = "Distance (u)"

#set_theme!(Theme(font = "Helvetica"))
#set_theme!()

distance = 0

data = DataFrame(CSV.File("PlacozoanStalker10_32 - " * distance * "radius.csv"))

d = ("data" * ".csv")

len = Int(data.rep[length(data.rep)])
frames = 150
threshold = 280
success = zeros(Int(len), frames)
fail = ones(Int(len), frames)

#adding data into raw dataframe
t = range(1, stop = frames)

#add data for successful predators
for i in 1:len
    #println(i)
    ra = findall(x -> x==i, data.rep)
    if (data.Range[last(ra)] < threshold)
        for y in 1:length(ra)
            success[i, y] = data.Range[y + (frames * (i-1))]
        end
    end
end

#plotting all lines of rawdata
for i in 1:len
    if (success[i,:] > [i])
        c = lines!(ax, success[i,:], markersize = 1, color = (:gray, 0.5))
    end
end

X = success
μ = vec(mean(X, dims = 1))
lines!(t, μ, markersize = 4)
σ = vec(std(X, dims = 1))
# band!(t, μ + σ, μ - σ)
SE = (σ./(len^2))
band!(t, μ + SE, μ - SE)

#add data for unsuccessful predators
for i in 1:len
    #println(i)
    ra = findall(x -> x==i, data.rep)
    if (data.Range[last(ra)] > threshold)
        for y in 1:length(ra)
            fail[i, y] = data.Range[y + (frames * (i-1))]
        end
    end
end
#
# X = fail
# μ = vec(mean(X, dims = 1))
# lines!(t, μ)
# σ = vec(std(X, dims = 1))
# band!(t, μ + σ, μ - σ)
# SE = (σ./(len^2))
# band!(t, μ + SE, μ - SE)

#plotting all lines of fail
for i in 1:len
    if (fail[i,:] > [1])
        c = lines!(ax, fail[i,:], markersize = 1, color = :red)
    end
end

#save("static.png", f)
display(f)
