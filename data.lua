-- This file is for use with Moai SDK
-- 
-- This file is automatically generated with TexturePacker (http://www.codeandweb.com/texturepacker). Do not edit
-- {{smartUpdateKey}}
-- 
{% load MoaiExport %}
{% if exporterProperties.moaiContentScaleSwitch %} {{variantParams.commonDivisorX|setContentScale}} {% endif %}

return {
	version = 2.0,
    texture = "{{texture.fullName}}",
    frames = {{allSprites|writeSprites}}
}
