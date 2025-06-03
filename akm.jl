using Distributions
using LinearAlgebra
using Plots

# Parameters
struct Params
    nk::Int        # firm types
    nl::Int        # worker types
    alpha_sd::Float64
    psi_sd::Float64
    lambda::Float64
    csort::Float64
    cnetw::Float64
    csig::Float64
    psi::Vector{Float64}
    alpha::Vector{Float64}
end

function create_params()
    # Initialize basic parameters
    nk = 30  # firm types
    nl = 10  # worker types
    alpha_sd = 1.0
    psi_sd = 1.0
    lambda = 0.05
    csort = 0.5  # sorting effect
    cnetw = 0.2  # network effect
    csig = 0.5

    # Create firm and worker fixed effects
    psi = quantile.(Normal(0, psi_sd), range(1/(nk+1), 1-1/(nk+1), length=nk))
    alpha = quantile.(Normal(0, alpha_sd), range(1/(nl+1), 1-1/(nl+1), length=nl))

    return Params(nk, nl, alpha_sd, psi_sd, lambda, csort, cnetw, csig, psi, alpha)
end

function get_G(p::Params)
    # Create transition matrices
    G = zeros(p.nl, p.nk, p.nk)
    
    for l in 1:p.nl, k in 1:p.nk
        # Probability of moving is highest if pdf(Normal(), 0)
        G[l, k, :] = pdf.(Normal(0, p.csig), p.psi .- p.cnetw * p.psi[k] .- p.csort * p.alpha[l])
        # Normalize to get transition matrix
        G[l, k, :] ./= sum(G[l, k, :])
    end
    
    return G
end

function get_H(p::Params, G)
    # Solve for stationary distribution over psis for each alpha value
    H = fill(1/p.nk, (p.nl, p.nk))
    
    for l in 1:p.nl
        M = G[l, :, :]
        for i in 1:100
            H[l, :] = M' * H[l, :]
        end
    end
    
    return H
end

# Create parameters and compute matrices
p = create_params()
G = get_G(p)
H = get_H(p, G)

# Plotting
function plot_transition_matrices()
    # Plot first worker type transition matrix
    p1 = heatmap(G[1, :, :], 
                 title="Worker Type 1 Transition Matrix",
                 xlabel="Next Firm",
                 ylabel="Previous Firm")
    
    # Plot last worker type transition matrix
    p2 = heatmap(G[end, :, :],
                 title="Worker Type $(p.nl) Transition Matrix",
                 xlabel="Next Firm",
                 ylabel="Previous Firm")
    
    # Combine plots
    plot(p1, p2, layout=(1,2), size=(1000,400))
    
    # Save the plot
    savefig("transition_matrices.png")
end

function plot_joint_distribution()
    # Create labels for the axes
    worker_labels = round.(p.alpha, digits=2)
    firm_labels = round.(p.psi, digits=2)
    
    # Create heatmap of the joint distribution
    h = heatmap(firm_labels, worker_labels, H,
                xlabel="Firm Type (ψ)",
                ylabel="Worker Type (α)",
                title="Joint Distribution of Matches",
                c=:viridis,  # color scheme
                aspect_ratio=:equal,
                size=(800,600))
    
    # Add colorbar label
    plot!(h, colorbar_title="Probability")
    
    # Save the plot
    savefig("joint_distribution.png")
end

# Generate and save the plots
plot_transition_matrices()
plot_joint_distribution()
println("Plots have been saved as 'transition_matrices.png' and 'joint_distribution.png'")