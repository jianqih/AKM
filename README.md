# AKM (Abowd-Kramarz-Margolis) Model Implementation

This repository contains an implementation of the Abowd-Kramarz-Margolis (AKM) model for analyzing worker-firm matching patterns. The project includes both theoretical documentation and computational implementation.

## Overview

The AKM model is used to study the sorting of workers across firms and the dynamics of worker mobility. This implementation focuses on:

- Worker-firm matching with heterogeneous types
- Transition matrices for job mobility
- Stationary distributions of matches
- Visualization of matching patterns

## Files

- `akm.jl` - Julia implementation of the AKM model
- `AKM.tex` - LaTeX documentation of the theoretical model
- `AKM.pdf` - Compiled PDF documentation
- `transition_matrices.png` - Visualization of transition matrices
- `joint_distribution.png` - Heatmap of the joint distribution of matches

## Requirements

### Julia Dependencies
```julia
using Pkg
Pkg.add(["Distributions", "Plots", "LinearAlgebra"])
```

### LaTeX Dependencies
- PDFLaTeX
- Standard mathematical packages

## Usage

### Running the Julia Code

```bash
julia akm.jl
```

This will:
1. Create parameter structures for the model
2. Generate transition matrices for different worker types
3. Compute stationary distributions
4. Generate and save visualization plots

### Compiling the Documentation

```bash
pdflatex AKM.tex
```

## Model Parameters

The model includes the following key parameters:

- `nk`: Number of firm types (default: 30)
- `nl`: Number of worker types (default: 10)
- `csort`: Sorting effect parameter (default: 0.5)
- `cnetw`: Network effect parameter (default: 0.2)
- `csig`: Variance parameter (default: 0.5)

## Output

The code generates two main visualizations:

1. **Transition Matrices**: Shows how workers of different types transition between firms
2. **Joint Distribution**: Displays the stationary distribution of worker-firm matches

## Model Structure

The implementation uses:
- Firm fixed effects (ψ) drawn from a normal distribution
- Worker fixed effects (α) drawn from a normal distribution
- Transition probabilities based on sorting and network effects
- Iterative computation of stationary distributions

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License. 