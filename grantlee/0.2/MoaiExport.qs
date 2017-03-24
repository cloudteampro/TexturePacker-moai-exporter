
var writeSprites = function(allSprites) {
    var output = "{\n";

    for ( var i = 0; i < allSprites.length; i++ ) {
        var sp = writeSprite(allSprites[i]);
        output += sp + ",\n";
    }
    
    output += "    }";
    return output;
}
writeSprites.filterName = "writeSprites";
Library.addFilter("writeSprites");

contentScale = 1.0;

var setContentScale = function(scl) {
    contentScale = scl;
    return "";
}
setContentScale.filterName = "setContentScale";
Library.addFilter("setContentScale");


var writeSprite = function(sprite) {

    var rectTop = sprite.pivotPoint.y - sprite.sourceRect.y;
    var rectBot = rectTop - sprite.sourceRect.height;
    var rectLeft = sprite.sourceRect.x - sprite.pivotPoint.x;
    var rectRight = rectLeft + sprite.sourceRect.width;

    var boundsTop = sprite.pivotPoint.y;
    var boundsBot = boundsTop - sprite.untrimmedSize.height;
    var boundsLeft = -sprite.pivotPoint.x;
    var boundsRight = boundsLeft + sprite.untrimmedSize.width;
    
    var output = "succ\n";
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

    // if ( sprite.scale9Enabled ) {
    //     output += sprite.scale9Borders.x + ";";
    //     output += sprite.frameRect.width - sprite.scale9Borders.x - sprite.scale9Borders.width + ";";
    //     output += sprite.scale9Borders.y + ";";
    //     output += sprite.frameRect.height - sprite.scale9Borders.y - sprite.scale9Borders.height + ";";
    // }

    output += pad2 + "}"

    // if (sprite.vertices.length > 0) {
    //     output += PrintVertices(sprite) + ";"
    // }

    return output;
}

// var PrintVertices = function(sprite) {
// 
//     var height = sprite.frameRect.height
//     var str = ''
//     var vertices = sprite.vertices
//     var sourceRect = sprite.sourceRect
//     str += " " + vertices.length
//     for (var i = 0; i < vertices.length; i++) {
//         str += ";" + (vertices[i].x - sourceRect.x) +
//                ";" + (height - vertices[i].y + sourceRect.y)
//     }
//     var triangleIndices = sprite.triangleIndices
//     str += "; " + triangleIndices.length / 3;
//     for (i = 0; i < triangleIndices.length; i++) {
//         str += ";" + triangleIndices[i]
//     }
//     return str
// };
