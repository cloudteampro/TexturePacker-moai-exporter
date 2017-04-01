
var writeSprites = function ( tp ) {
    var output = "{\n";

    var width = tp.texture.size.width;
    var height = tp.texture.size.height;

    contentScale = contentScale * tp.variantParams.scale;

    for ( var i = 0; i < tp.allSprites.length; i++ ) {
        var sp = writeSprite ( tp.allSprites [ i ], width, height );
        output += sp + ",\n";
    }
    
    output += "    }";
    return output;
}
writeSprites.filterName = "writeSprites";
Library.addFilter ( "writeSprites" );

contentScale = 1.0;

var setContentScale = function ( scl ) {
    var s = scl.rawString ();
    var num = parseInt(s);
    contentScale = s;
    return "";
}
setContentScale.filterName = "setContentScale";
Library.addFilter ( "setContentScale" );

var getContentScale = function ( scl ) {
    return '' + (contentScale * scl);
}
getContentScale.filterName = "getContentScale";
Library.addFilter ( "getContentScale" );


var writeSprite = function ( sprite, textureWidth, textureHeight ) {

    var rectTop = sprite.pivotPoint.y - sprite.sourceRect.y;
    var rectBot = rectTop - sprite.sourceRect.height;
    var rectLeft = sprite.sourceRect.x - sprite.pivotPoint.x;
    var rectRight = rectLeft + sprite.sourceRect.width;

    var boundsTop = sprite.pivotPoint.y;
    var boundsBot = boundsTop - sprite.untrimmedSize.height;
    var boundsLeft = -sprite.pivotPoint.x;
    var boundsRight = boundsLeft + sprite.untrimmedSize.width;
    
    var pad = "    ";
    var pad2 = pad + pad;
    var pad3 = pad2 + pad;
    var output = pad2 + "{\n";

    output += pad3 + "name = \"" + sprite.fullName + "\",\n";
    
    var v0 = sprite.frameRectRel.y;
    var v1 = v0 + sprite.frameRectRel.height;
    var u0 = sprite.frameRectRel.x;
    var u1 = u0 + sprite.frameRectRel.width;
    var s = 1.0 / contentScale;

    output += pad3 + "rect = {";
    output += s * rectLeft + ", " + s * rectBot + ", " + s * rectRight + ", " + s * rectTop + "},\n";

    output += pad3 + "bounds = {";
    output += s * boundsLeft + ", " + s * boundsBot + ", " + s * boundsRight + ", " + s * boundsTop + "},\n";

    if ( sprite.rotated ) {
        output += pad3 + "uvQuad = {";
        output += u1 + ", " + v0 + ", " + u1 + ", " + v1 + ", " + u0 + ", " + v1 + ", " + u0 + ", " + v0 + "},\n";
    }
    else {
        output += pad3 + "uvQuad = {";
        output += u0 + ", " + v0 + ", " + u1 + ", " + v0 + ", " + u1 + ", " + v1 + ", " + u0 + ", " + v1 + "},\n";
    }

    if ( sprite.scale9Enabled ) {
        output += pad3 + "stretch = {"
        output += "x = " + sprite.scale9Borders.x + ", ";
        output += "y = " + sprite.scale9Borders.y + ", ";
        output += "w = " + sprite.scale9Borders.width + ", ";
        output += "h = " + sprite.scale9Borders.height + "},\n";
    }

    if ( sprite.vertices.length > 0 ) {
        output += PrintVertices ( sprite, textureWidth, textureHeight );
    }

    output += pad2 + "}"

    return output;
}

var PrintVertices = function ( sprite, textureWidth, textureHeight ) {
    
    var pad = "    ";
    var pad2 = pad + pad;
    var pad3 = pad2 + pad;

    var height = sprite.frameRect.height;
    var str =  pad3 + "vtx = {";
    var vertices = sprite.vertices;
    var verticesUV = sprite.verticesUV;
    
    for ( var i = 0; i < vertices.length; i++ ) {
        str += ( vertices [ i ].x - sprite.pivotPoint.x ) + ", " + ( sprite.pivotPoint.y - vertices [ i ].y ) + ", ";
    }
    str += "},\n";

    str += pad3 + "uvs = {";
    for ( var i = 0; i < verticesUV.length; i++ ) {
        str += ( verticesUV [ i ].x / textureWidth ) + ", " + ( verticesUV [ i ].y / textureHeight ) + ", ";
    }
    str += "},\n";

    var triangleIndices = sprite.triangleIndices
    str += pad3 + "idx = {";
    for ( i = 0; i < triangleIndices.length; i++ ) {
        str += triangleIndices [ i ] + ", ";
    }
    str += "},\n";
    return str
};



var introspect = function(value, name, indent)
{
    indent = indent || "";
    name = name || "";

    if (value === null)
    {
        return indent+name+" = null";
    }

    var objType = typeof value;
    var info = indent+name+" = ";

    if (objType === "undefined")
    {
        return info+"undefined\n";
    }
    else if (objType === "object")
    {
        var propInfo = "";
        var prop;
        for (prop in value)
        {
            if(prop !== "objectName") // ignore objectName - it's currently empty
            {
                var p = introspect(value[prop], prop, indent+"    ");
                if(p !== "")
                {
                    propInfo += p +"\n";
                }
            }
        }
        if(propInfo==="")
        {
            info += "{"+value+"}";
        }
        else
        {
            info += "{\n" + propInfo +indent+"}";
        }
    }
    else if (objType === "function")
    {
        return "";
    }
    else {
        info+=value;
    }

    return info;
};

// print some detail about object {{value|makeRelY}}
var ObjectInfo = function(input)
{
    return introspect(input);
};
ObjectInfo.filterName = "objectInfo";
ObjectInfo.isSafe = true;
Library.addFilter("ObjectInfo");

