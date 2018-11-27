return {
    ["BLOB-ABSENT"] = EnemyBlueprint("BLOBBY", assets.blueprints['blob'], constants.ENEMY.BLOB.YIELD, true, constants.ENEMY.BLOB.HEALTH, function(params)
        return Blob(params.origin)
    end),
    ["BLOB-ABSENT-LARGE"] = EnemyBlueprint("BIG BLOBBY", assets.blueprints['blob'], constants.ENEMY.BLOBLARGE.YIELD, false, constants.ENEMY.BLOBLARGE.HEALTH, function(params)
        return BlobLarge(params.origin)
    end),
    ["BLOB-FIRE"] = EnemyBlueprint("FLAREY", assets.blueprints['blob-fire'], constants.ENEMY.BLOBFIRE.YIELD, true, constants.ENEMY.BLOBFIRE.HEALTH, function(params)
        return BlobFire(params.origin)
    end),
    ["BLOB-FIRE-LARGE"] = EnemyBlueprint("BIG FLAREY", assets.blueprints['blob-fire'], constants.ENEMY.BLOBFIRELARGE.YIELD, false, constants.ENEMY.BLOBFIRELARGE.HEALTH, function(params)
        return BlobFireLarge(params.origin)
    end),
    ["BLOB-ICE"] = EnemyBlueprint("ICEY", assets.blueprints['blob-ice'], constants.ENEMY.BLOBICE.YIELD, true, constants.ENEMY.BLOBICE.HEALTH, function(params)
        return BlobIce(params.origin)
    end),
    ["BLOB-ICE-LARGE"] = EnemyBlueprint("BIG ICEY", assets.blueprints['blob-ice'], constants.ENEMY.BLOBICELARGE.YIELD, false, constants.ENEMY.BLOBICELARGE.HEALTH, function(params)
        return BlobIceLarge(params.origin)
    end),
    ["BLOB-SPARK"] = EnemyBlueprint("SPARKY", assets.blueprints['blob-electric'], constants.ENEMY.BLOBSPARK.YIELD, true, constants.ENEMY.BLOBSPARK.HEALTH, function(params)
        return BlobSpark(params.origin)
    end),
    ["BLOB-SPARK-LARGE"] = EnemyBlueprint("BIG SPARKY", assets.blueprints['blob-electric'], constants.ENEMY.BLOBSPARKLARGE.YIELD, false, constants.ENEMY.BLOBSPARKLARGE.HEALTH, function(params)
        return BlobSparkLarge(params.origin)
    end),
    ["BLOB-SKULL"] = EnemyBlueprint("BLOB (SKULL)", assets.blueprints['blob-skull'], constants.ENEMY.BLOBSKULL.YIELD, false, constants.ENEMY.BLOBSKULL.HEALTH, function(params)
        return BlobSkull(params.origin)
    end),
    ["BLOB-TEETH"] = EnemyBlueprint("BLOB (TEETH)", assets.blueprints['blob-teeth'], constants.ENEMY.BLOBTEETH.YIELD, false, constants.ENEMY.BLOBTEETH.HEALTH, function(params)
        return BlobTeeth(params.origin)
    end),
}