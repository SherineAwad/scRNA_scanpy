with open(config['SAMPLES']) as fp:
    samples = fp.read().splitlines()



rule all:
         input:
            expand("{all}.h5ad", all= config['ALL']), 
            #expand("corrected_{all}.h5ad", all=config['ALL']),
            #expand("clustered_{all}.h5ad", all=config['ALL']), 
            #expand("annotated_{all}.h5ad", all=config['ALL'])
 
rule preprocess: 
        input:  
            expand("{sample}_filtered_feature_bc_matrix.h5", sample = samples) 
        output: 
          expand("{all}.h5ad", all= config['ALL']), 
        params: 
          samples = config['SAMPLES'],  
          name = config['ALL']
        shell: 
            """
           python preprocess.py {params.samples}  {params.name}  
           """ 

rule batch: 
     input: 
         expand("{all}.h5ad", all=config['ALL'])
     output: 
         expand("corrected_{all}.h5ad", all=config['ALL'])
     shell: 
        """ 
        python batch.py {input} 
        """ 


rule analyse: 
     input: 
        expand("corrected_{all}.h5ad", all=config['ALL'])
     output: 
        expand("analysed_{all}.h5ad", all=config['ALL'])
     shell:
        """
        python analyse.py {input}
        """

rule cluster: 
       input:
          expand("corrected_{all}.h5ad", all=config['ALL']) 
       output:
          expand("clustered_{all}.h5ad", all=config['ALL'])
       shell:
          """
          python cluster.py {input}
          """

rule annotate:
       input:
          expand("clustered_{all}.h5ad", all=config['ALL'])
       output:
          expand("annotated_{all}.h5ad", all=config['ALL'])
       shell:
          """
          python annotate.py {input}
          """


