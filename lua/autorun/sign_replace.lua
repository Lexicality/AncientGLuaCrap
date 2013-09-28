--[[ Replace sign with post sign ]]--
if game.GetMap():lower() ~= "rp_evocity_v2d" or not cider then return end
if SERVER then
	      AddCSLuaFile"autorun/sign_replace.lua"
	      resource.AddFile"evocityextrude.vmt"
	      resource.AddFile"evocityextrude.vtf"
	      resource.AddFile"evocityextrude_normal.vtf"
	      resource.AddFile"evocityintrude.vmt"
	      resource.AddFile"evocityintrude_s.vtf"
	      resource.AddFile"evocityintrude_s_normal.vtf"
else
	      local mat = Material	            "maps/rp_evocity_v2pdless/sgtsicktextures/bankofamericasign_-6363_-7696_137"--"SGTSICKTEXTURES/BANKOFAMERICASIGN"
	      local met = Material	            "evocityextrude"
	      mat:SetMaterialTexture(	            "$basetexture", met:GetMaterialTexture"$basetexture")
	      mat:SetMaterialTexture(	            "$bumpmap",     met:GetMaterialTexture"$bumpmap"    )

	      local mot = Material	            "SGTSICKTEXTURES/BANKOAMERICA2"
	      local mut = Material	            "evocityintrude"
	      mot:SetMaterialTexture(	            "$basetexture", mut:GetMaterialTexture"$basetexture")
	      --[
	      mot:SetMaterialTexture(	            "$bumpmap",     mut:GetMaterialTexture"$bumpmap"    )
	      mot:SetMaterialInt(           "$normalmapalphaenvmapmask", 1					        )
	      --]]
	      mot:SetMaterialTexture(       "$envmap",      mat:GetMaterialTexture"$envmap"     )
    mot:SetMaterialString(        "$envmaptint", "[ .3 .3 .45 ]")
end
