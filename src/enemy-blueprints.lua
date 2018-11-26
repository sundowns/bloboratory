return {
    ["BLOB"] = EnemyBlueprint("BLOB", assets.blueprints['blob'], constants.ENEMY.BLOB.YIELD, false, function(params)
        return Blob(params.origin)
    end),
    ["BLOB-LARGE"] = EnemyBlueprint("LARGE BLOB", assets.blueprints['blob'], constants.ENEMY.BLOBLARGE.YIELD, false, function(params)
        return BlobLarge(params.origin)
    end),
    ["BLOB-FIRE"] = EnemyBlueprint("FIRE BLOB", assets.blueprints['blob-fire'], constants.ENEMY.BLOBFIRE.YIELD, false, function(params)
        return BlobFire(params.origin)
    end),
    ["BLOB-FIRE-LARGE"] = EnemyBlueprint("LARGE FIRE BLOB", assets.blueprints['blob-fire'], constants.ENEMY.BLOBFIRELARGE.YIELD, false, function(params)
        return BlobFireLarge(params.origin)
    end),
    ["BLOB-ICE"] = EnemyBlueprint("ICE BLOB", assets.blueprints['blob-ice'], constants.ENEMY.BLOBICE.YIELD, false, function(params)
        return BlobIce(params.origin)
    end),
    ["BLOB-ICE-LARGE"] = EnemyBlueprint("LARGE ICE BLOB", assets.blueprints['blob-ice'], constants.ENEMY.BLOBICELARGE.YIELD, false, function(params)
        return BlobIceLarge(params.origin)
    end),
    ["BLOB-SPARK"] = EnemyBlueprint("SPARK BLOB", assets.blueprints['blob-electric'], constants.ENEMY.BLOBSPARK.YIELD, false, function(params)
        return BlobSpark(params.origin)
    end),
    ["BLOB-SPARK-LARGE"] = EnemyBlueprint("LARGE SPARK BLOB", assets.blueprints['blob-electric'], constants.ENEMY.BLOBSPARKLARGE.YIELD, false, function(params)
        return BlobSparkLarge(params.origin)
    end),
    ["BLOB-SKULL"] = EnemyBlueprint("BLOB (SKULL)", assets.blueprints['blob-skull'], constants.ENEMY.BLOBSKULL.YIELD, true, function(params)
        return BlobSkull(params.origin)
    end),
    ["BLOB-TEETH"] = EnemyBlueprint("BLOB (TEETH)", assets.blueprints['blob-teeth'], constants.ENEMY.BLOBTEETH.YIELD, true, function(params)
        return BlobTeeth(params.origin)
    end),
}