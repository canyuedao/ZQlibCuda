#ifndef _ZQ_CUDA_POISSON_SOLVER_3D_OPEN_FLUX_CUH_
#define _ZQ_CUDA_POISSON_SOLVER_3D_OPEN_FLUX_CUH_

#include "ZQ_CUDA_PoissonSolver3D.cuh"

namespace ZQ_CUDA_PoissonSolver3D
{
	/*Open Flux Model
	*	minimize \int{||\mathbf{x}||^2} 
	*	s.t.  \nabla \cdot (\mathbf{x} + \mathbf{u}) = 0
	*	------------------------------------------------
	*	Augmented Lagranged Multiplier method
	*	Let div := \nabla \cdot \mathbf{u}
	*	for(each outer iter)
	*	{
	*		minimize_{x} \int x^2 - \lambda (\nabla \cdot x + div) + coeff/2*(\nabla \cdot x + div)^2   (1)
	*		\lambda -= coeff*(\nabla \cdot x + div);
	*		increase coeff
	*	}
	*	----------------------------------------------
	*	The first implementation use red-black methd to solve Eq.1
	*
	*/
	
	/*********************  CUDA functions   *************************/
	
	/* First Implementation
	* outer iteration: Augmented Lagrange Multiplier method
	* inner iteration: red-black iteration
	*/
	void cu_SolveOpenFluxRedBlack_MAC(float* mac_u, float* mac_v, float* mac_w, const int width, const int height, const int depth, const int outerIter, const int innerIter);
	
	void cu_SolveOpenFluxRedBlack_Regular(float* u, float* v, float* w, const int width, const int height, const int depth, const int outerIter, const int innerIter);
	
	void cu_SolveOpenFluxRedBlackwithOccupy_MAC(float* mac_u, float* mac_v, float* mac_w, const bool* occupy, const int width, const int height, const int depth, const int outerIter, const int innerIter);
	
	void cu_SolveOpenFluxRedBlackwithFaceRatio_MAC(float* mac_u, float* mac_v, float* mac_w, const bool* occupy, const float* unoccupyU, const float* unoccupyV, const float* unoccupyW,
													const int width, const int height, const int depth, const int outerIter, const int innerIter);
												

	/*********************  Kernel functions       *************************/
	
	/****** First Implementation OpenFlux kernels  *****/
	__global__
	void SolveFlux_OpenFlux_u_RedBlack_Kernel(float* out_du, const float* du, const float* dv, const float* dw, const float* divergence, const float* lambda, const float aug_coeff,
										const int width, const int height, const int depth, const bool redkernel);

	__global__
	void SolveFlux_OpenFlux_v_RedBlack_Kernel(float* out_dv, const float* du, const float* dv, const float* dw, const float* divergence, const float* lambda, const float aug_coeff,
										const int width, const int height, const int depth, const bool redkernel);
										
	__global__
	void SolveFlux_OpenFlux_w_RedBlack_Kernel(float* out_dw, const float* du, const float* dv, const float* dw, const float* divergence, const float* lambda, const float aug_coeff,
										const int width, const int height, const int depth, const bool redkernel);

	__global__
	void SolveFlux_OpenFlux_occupy_u_RedBlack_Kernel(float* out_du, const float* du, const float* dv, const float* dw, const bool* occupy, const float* divergence, const float* lambda, const float aug_coeff,
										const int width, const int height, const int depth, const bool redkernel);

	__global__
	void SolveFlux_OpenFlux_occupy_v_RedBlack_Kernel(float* out_dv, const float* du, const float* dv, const float* dw, const bool* occupy, const float* divergence, const float* lambda, const float aug_coeff,
										const int width, const int height, const int depth, const bool redkernel);
										
	__global__
	void SolveFlux_OpenFlux_occupy_w_RedBlack_Kernel(float* out_dw, const float* du, const float* dv, const float* dw, const bool* occupy, const float* divergence, const float* lambda, const float aug_coeff,
										const int width, const int height, const int depth, const bool redkernel);
									
	__global__
	void SolveFlux_OpenFlux_FaceRatio_u_RedBlack_Kernel(float* out_du, const float* du, const float* dv, const float* dw, const bool* occupy, const float* unoccupyU, const float* unoccupyV,
										const float* unoccupyW, const float* divergence, const float* lambda, const float aug_coeff, const int width, const int height, const int depth, const bool redkernel);

	__global__
	void SolveFlux_OpenFlux_FaceRatio_v_RedBlack_Kernel(float* out_dv, const float* du, const float* dv, const float* dw, const bool* occupy, const float* unoccupyU, const float* unoccupyV,
										const float* unoccupyW, const float* divergence, const float* lambda, const float aug_coeff, const int width, const int height, const int depth, const bool kernel);
										
	__global__
	void SolveFlux_OpenFlux_FaceRatio_w_RedBlack_Kernel(float* out_dw, const float* du, const float* dv, const float* dw, const bool* occupy, const float* unoccupyU, const float* unoccupyV,
										const float* unoccupyW, const float* divergence, const float* lambda, const float aug_coeff, const int width, const int height, const int depth, const bool kernel);
								
		
}

#endif