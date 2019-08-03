#include <stdio.h>
#include <stdlib.h>

double determinant(double* m, const int N);

void print_matrix(double* m, const int N){
    for(int i=0; i<N; ++i){
        for(int j=0; j<N; ++j){
            fprintf(stdout,"%.2f ",m[i*N+j]);
        }
        fprintf(stdout, "\n");
    }
    fflush(stdout);
}

void initialize_matrix(double* m, const int N){
    double rm = RAND_MAX/2;
    for(int i=0; i<N; ++i){
        for(int j=0; j<N; ++j){
            //if over RAND_MAX/2 then positive else negative
            m[i*N+j] = (rand()-rm)/(rm/4);
        }
    }
}

double* ablate_matrix(double* m, const int N, int row, int col){
    //allocate submatrix
    double* s = (double*)malloc((N-1)*(N-1)*sizeof(double));
    //start initializing elements of submatrix
    //take all rows except the specified
    for(int i=0; i<row; ++i){
        //all columns up to col
        for(int k=0; k<col; ++k){
            s[(i)*(N-1) + k] = m[i*N + k];
        }
        //all columns after col
        for(int k=col+1; k<N; ++k){
            s[(i)*(N-1) + k-1] = m[i*N + k];
        }
    }
    for(int i=row+1; i<N; ++i){
        //all columns up to col
        for(int k=0; k<col; ++k){
            s[(i-1)*(N-1) + k] = m[i*N + k];
        }
        //all columns after col
        for(int k=col+1; k<N; ++k){
            s[(i-1)*(N-1) + k-1] = m[i*N + k];
        }
    }
    return s;
}

double* get_minors(double* m, const int N){
    double* minors = (double*)malloc(N*sizeof(double));
    for(int j=0; j<N; ++j){
        //create submatrix obtained by ablating row 0 and col j
        double* submat = ablate_matrix(m, N, 0, j);

        minors[j] = determinant(submat, N-1);
        
        free(submat);
    }
    return minors;
}

double determinant(double* m, const int N){
    //if side is 1 or 2, result is trivial
    if(N==1)
        return m[0];
    if(N==2)
        return (m[0]*m[3])-(m[1]*m[2]);
    
    //otherwise, get minors
    double* minors = get_minors(m, N);

    double det = 0.0;
    for(int j=0; j<N; ++j){
        //element of ablated row (0) and column (j) * corresponding minor *
        //positive or negative 1 depending on even/odd index
        det += m[j] * minors[j] * (j%2==0 ? 1 : -1);
    }
    free(minors);
    return det;
}

double* inverse(double* m, const int N){
    double det = determinant(m,N);
    if (det == 0){
        fprintf(stderr, "The matrix is singular hence its inverse doesn't exist");
    }else{
        double* mat_inverse = (double*)malloc(N*N*sizeof(double));
        for(int i=0;i<N;++i){
            for(int j=0; j<N; ++j){
                //Ablate columns and rows and place them into the inverse matrix
                //(with inverse index on cols and rows ablated)
                double* ablated = ablate_matrix(m,N,j,i);

                double det_ablated = determinant(ablated, N-1) * ((i+j)%2==0? 1: -1);
                free(ablated);
                //divide the determinant of the ablated by the determinant
                mat_inverse[i*N+j] = det_ablated / det;
            }
        }
        
        return mat_inverse;
    }
}

int main(int argc, char ** argv){
    //const int N = atoi(argv[1]);
    const int N = 10;
    double*mat = (double*)malloc(N*N*sizeof(double));
    
    initialize_matrix(mat, N);
    
    print_matrix(mat, N);
    

    double det = determinant(mat, N);

    fprintf(stdout, "Determinant is %.2f\n", det);

    double* inv = inverse(mat, N);

    fprintf(stdout, "Inverse is:\n");

    print_matrix(inv, N);

    free(mat);
    free(inv);
}
