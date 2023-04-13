// Enable DSL 2
nextflow.enable.dsl = 2

// Using version: 23.03.0-edge 

config_ch = Channel
            .fromPath( "data/sub-00[0-9].txt" , type: 'file', checkIfExists: true)
            .map { file_path -> tuple( file_path.name, file_path ) }

config_ch.view()

// Process to check if all process where successful

// Process to check if all the steps were completed
process ReadFiles {
    fair true
    cache 'lenient'
    tag "${sub_id}_ReadFile"    
    publishDir "data/", mode: 'copy'
    
    errorStrategy = 'ignore'    
    time = '1m'
    cpus = 1
    memory = '500 MB'

    input:        
    tuple val(sub_id), file(config_file)    

    output:
    tuple val(sub_id), file("ReadFile_${sub_id}")
    
    script:    
    """
    # Filenames with format sub-00[0-9].txt. If the ID is bigger than 003 and smaller than 007 it fails and 
    # throws an error.
    echo ${sub_id} > ReadFile_${sub_id}
    sub_num=\$(echo ${sub_id} | cut -d'-' -f2 | cut -d'.' -f1)
    if [ \$sub_num -gt 003 ] && [ \$sub_num -lt 007 ]; then
        echo "Error"
        exit 1
    fi    
    """
}

process DummyProcess {
    fair true
    cache 'lenient'
    tag "${sub_id}_Dummy"    
    publishDir "data/", mode: 'copy'
    
    errorStrategy = 'ignore'    
    time = '1m'
    cpus = 1
    memory = '500 MB'

    input:        
    tuple val(sub_id), file(previous_file)    

    output:
    tuple val(sub_id), file("Dummy_${sub_id}")
    
    script:    
    """
    # Just a dummy process after the first one
    echo "Dummy" > Dummy_${sub_id}
    """
}

process DummyProcess2 {
    fair true
    cache 'lenient'
    tag "${sub_id}_Dummy2"    
    publishDir "data/", mode: 'copy'
    
    errorStrategy = 'ignore'    
    time = '1m'
    cpus = 1
    memory = '500 MB'

    input:        
    tuple val(sub_id), file(previous_file)    

    output:
    tuple val(sub_id), file("Dummy2_${sub_id}")
    
    script:    
    """
    # Just a dummy process after the first one
    echo "Dummy" > Dummy2_${sub_id}
    """
}

workflow {     
    
    // Read the files
    ReadFiles( config_ch )

    // Pass it to the dummy process 1
    DummyProcess( ReadFiles.out )

    // Pass it to the dummy process 2
    DummyProcess2( DummyProcess.out )

}