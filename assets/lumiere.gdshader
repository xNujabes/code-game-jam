shader_type canvas_item;

uniform vec2 light_position = vec2(0.5, 0.5); // Position de la lumière (dans les coordonnées locales).
uniform float radius : hint_range(0.0, 500.0) = 200.0; // Taille de la lumière.
uniform vec4 light_color : source_color = vec4(1.0, 1.0, 0.8, 1.0); // Couleur de la lumière.

void fragment() {
    // Calcul de la position relative du pixel par rapport à la lumière
    vec2 pos = UV - light_position; // UV pour des coordonnées locales [0, 1].
    float dist = length(pos) * SCREEN_PIXEL_SIZE.x * 500.0; // Ajuste à la taille de l'écran.

    // Intensity de la lumière basée sur la distance
    float intensity = smoothstep(radius, radius * 0.5, dist);

    // Couleur finale du pixel
    COLOR = mix(light_color, vec4(0.0, 0.0, 0.0, 1.0), intensity); // Mélange lumière et ombre.
}