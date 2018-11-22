return {
    ["BLOB"] = EnemyBlueprint("BLOB", assets.blueprints['blob'], constants.ENEMY.BLOB.YIELD, function(params)
        return Blob(params.origin)
    end),
    ["BLOB-FIRE"] = EnemyBlueprint("BLOB (FIRE)", assets.blueprints['blob-fire'], constants.ENEMY.BLOBFIRE.YIELD, function(params)
        return BlobFire(params.origin)
    end),
    ["BLOB-ICE"] = EnemyBlueprint("BLOB (ICE)", assets.blueprints['blob-ice'], constants.ENEMY.BLOBICE.YIELD, function(params)
        return BlobIce(params.origin)
    end),
    ["BLOB-ELECTRIC"] = EnemyBlueprint("BLOB (ELECTRIC)", assets.blueprints['blob-electric'], constants.ENEMY.BLOBELECTRIC.YIELD, function(params)
        return BlobElectric(params.origin)
    end),
    ["BLOB-SKULL"] = EnemyBlueprint("BLOB (SKULL)", assets.blueprints['blob-fire'], constants.ENEMY.BLOBSKULL.YIELD, function(params)
        return BlobSkull(params.origin)
    end),
}