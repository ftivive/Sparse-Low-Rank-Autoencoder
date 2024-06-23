# Sparse Low Rank Autoencoder
 Clutter Removal in Through the Wall Radar Imaging using Sparse Autoencoder with Low Rank Projection

## Description
<p align="justify"> 
Through-the-wall radar imaging is a sensing technology that can be employed by first responders to see through opaque barriers during search-and-rescue missions, or it can be deployed by law enforcement and military personnel to maintain situational awareness during tactical operations. However, strong reflections from the front wall and other obstacles pose significant challenges in detecting stationary targets. This paper introduces a learning-based approach to mitigate the effects of the wall and background clutter. A sparse autoencoder with low-rank projection has been developed to reduce wall clutter and enhance the target signal. The weights of the proposed autoencoder are determined by solving an augmented Lagrangian multiplier optimization problem, and the regularization parameters are optimized using Bayesian optimization techniques.
</p>



## Experimental Setup
<p align="justify"> 
In the Radar Imaging Laboratory of the Centre for Signal and Information Processing at the University of Wollongong, Australia, a stepped-frequency radar system was utilized for data collection. The radar system comprises a network analyzer that generates a stepped-frequency waveform, covering a frequency band from 1 GHz to 4 GHz with a step size of 7.5 MHz. It also includes a scanner designed to synthesize a linear array aperture with a length of 1.5 meters and 41 elements. The radar system was positioned inside a room without an RF absorber, and a hollow wooden partition with a thickness of 0.08 meters served as a wall.
</p>
