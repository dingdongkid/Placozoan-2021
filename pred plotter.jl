using CSV
using DataFrames
using GLMakie
using Colors
using Statistics

f = Figure(resolution = (800, 800))
ax = f[1,1] = Axis(f)
xlims!(ax, 0, 150)
ylims!(ax, 0, 400)

data = DataFrame(CSV.File("PlacozoanStalker10_32 - average.csv"))

len = Int(data.rep[length(data.rep)])
frames = 150
rawdata = zeros(Int(len), frames)

#=
pd_plt = poly!(ax,
    decompose(Point2f0, Circle(Point2f0(0., 0.), 265)),
    color=(:red, 0.3), strokewidth=0, strokecolor=:black)
p_plt = poly!(ax,
    decompose(Point2f0, Circle(Point2f0(0., 0.), 120)),
    color=(:green, 0.3), strokewidth=0, strokecolor=:black)
=#

#hidespines!(ax)
#hidedecorations!(ax)

#=
#plotting predator location throughout closer approaches
for i in 1:len
    #println(data.rep)
    r = findall(x -> x==i, data.rep)
    m = findall(!iszero, data.MN[r])
    if (data.Range[r[150]] < 400)
        s = lines!(ax, -data.predatorx[r], data.predatory[r],
            markersize = 1, color=[:black for i in 1:length(r)])
        mn_color = [:black for i in 1:length(r)]
        mn_color[m] .= :red
        s.color[] = mn_color
    end
end
=#

#adding data into raw dataframe
t = range(1, stop = frames)

#add data for successful predators
for i in 1:len
    #println(i)
    ra = findall(x -> x==i, data.rep)
    if (data.Range[last(ra)] < 300)
        for y in 1:length(ra)
            rawdata[i, y] = data.Range[y + (frames * (i-1))]
        end
    end
end

#plotting all lines of rawdata
for i in 1:len
    c = scatter!(ax, rawdata[i,:], markersize = 1)
end

X = rawdata
μ = vec(mean(X, dims = 1))
d = μ .- 5
lines!(t, d)
σ = vec(std(X, dims = 1))
#band!(t, μ + σ, μ - σ)
SE = (σ./(len^2))
band!(t, d + SE, d - SE)

#add data for all predators
for i in 1:len
    #println(i)
    ra = findall(x -> x==i, data.rep)
    for y in 1:length(ra)
        rawdata[i, y] = data.Range[y + (frames * (i-1))]
    end
end

X = rawdata
μ = vec(mean(X, dims = 1))
d = μ .- 120
lines!(t, d)
σ = vec(std(X, dims = 1))
#band!(t, μ + σ, μ - σ)
SE = (σ./(len^2))
band!(t, d + SE, d - SE)

#plotting all lines of rawdata
for i in 1:len
    if (rawdata[i,:]  0)
        c = scatter!(ax, rawdata[i,:], markersize = 1)
    end
end

# #plotting predator location when prey detects
# for i in 1:len
#     #println(data.rep)
#     r = findall(x -> x==i, data.rep)
#     m = findall(!iszero, data.MN[r])
#     m .+= 150*(i-1)
#     #println(m)
#     if (length(m) > 0 && data.Range[last(m)] < 400)
#         s = scatter!(ax, data.predatorx[m], data.predatory[m],
#             markersize = 1, color=[:black for i in 1:length(m)])
#     end
# end

#Makie.save("prey.png", f)
display(f)
