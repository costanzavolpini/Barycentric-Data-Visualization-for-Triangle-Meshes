#version 330 core
    layout (location = 0) in vec3 aPos;
    layout (location = 1) in vec3 aNormal; 
    layout (location = 2) in vec3 aCoord;

    struct Light {
        vec3 direction;
    
        vec3 ambient;
        vec3 diffuse;
        vec3 specular;
    };

    out vec4 vertex_color;
    
    uniform mat4 model;
    uniform mat4 view;
    uniform mat4 projection;

    uniform vec3 viewPos; 
    uniform Light light;
    uniform float shininess;

    void main()
    {
        gl_Position =  projection * view * model * vec4(aPos, 1.0); 

        // ambient
        vec3 ambient = light.ambient;

        // diffuse 
        vec3 norm = normalize(aNormal);
        vec3 lightDir = normalize(-light.direction);
        float diff = max(dot(norm, lightDir), 0.0);
        vec3 diffuse = light.diffuse * diff;

        // specular
        vec3 viewDir = normalize(viewPos - aCoord);
        vec3 reflectDir = reflect(-lightDir, norm);  
        float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
        vec3 specular = light.specular * spec;

        vec3 result = (ambient + diffuse + specular) * vec3(gl_Position);
        vertex_color = vec4(result, 1.0f);
    
    }
