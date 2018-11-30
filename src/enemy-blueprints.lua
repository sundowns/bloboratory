return {
    ["BLOB-ABSENT"] = EnemyBlueprint("OOZE", assets.blueprints['blob'], constants.ENEMY.BLOB.YIELD, true, {0, 11}, constants.ENEMY.BLOB.HEALTH, function(params)
        return Blob(params.origin)
    end),
    ["BLOB-ABSENT-LARGE"] = EnemyBlueprint("GLOOP", assets.blueprints['blob-large'], constants.ENEMY.BLOBLARGE.YIELD, false, {6, 26}, constants.ENEMY.BLOBLARGE.HEALTH, function(params)
        return BlobLarge(params.origin)
    end),
    ["BLOB-FIRE"] = EnemyBlueprint("HOTTY", assets.blueprints['blob-fire'], constants.ENEMY.BLOBFIRE.YIELD, true, {0, 21}, constants.ENEMY.BLOBFIRE.HEALTH, function(params)
        return BlobFire(params.origin)
    end),
    ["BLOB-FIRE-LARGE"] = EnemyBlueprint("HOTTEST", assets.blueprints['blob-fire-large'], constants.ENEMY.BLOBFIRELARGE.YIELD, false, {11, 26}, constants.ENEMY.BLOBFIRELARGE.HEALTH, function(params)
        return BlobFireLarge(params.origin)
    end),
    ["BLOB-ICE"] = EnemyBlueprint("DRIP", assets.blueprints['blob-ice'], constants.ENEMY.BLOBICE.YIELD, true, {0, 21}, constants.ENEMY.BLOBICE.HEALTH, function(params)
        return BlobIce(params.origin)
    end),
    ["BLOB-ICE-LARGE"] = EnemyBlueprint("TRICKLE", assets.blueprints['blob-ice-large'], constants.ENEMY.BLOBICELARGE.YIELD, false, {11, 26}, constants.ENEMY.BLOBICELARGE.HEALTH, function(params)
        return BlobIceLarge(params.origin)
    end),
    ["BLOB-ELECTRIC"] = EnemyBlueprint("SPARK", assets.blueprints['blob-electric'], constants.ENEMY.BLOBELECTRIC.YIELD, true, {0, 21}, constants.ENEMY.BLOBELECTRIC.HEALTH, function(params)
        return BlobElectric(params.origin)
    end),
    ["BLOB-ELECTRIC-LARGE"] = EnemyBlueprint("BOLT", assets.blueprints['blob-electric-large'], constants.ENEMY.BLOBELECTRICLARGE.YIELD, false, {11, 26}, constants.ENEMY.BLOBELECTRICLARGE.HEALTH, function(params)
        return BlobElectricLarge(params.origin)
    end),
    ["BLOB-SKULL"] = EnemyBlueprint("BONEHEAD", assets.blueprints['blob-skull'], constants.ENEMY.BLOBSKULL.YIELD, false, {21, 31}, constants.ENEMY.BLOBSKULL.HEALTH, function(params)
        return BlobSkull(params.origin)
    end),
    ["BLOB-SKULL-DARK"] = EnemyBlueprint("NUMBSKULL", assets.blueprints['blob-skull-dark'], constants.ENEMY.BLOBSKULL_DARK.YIELD, false, {26, 31}, constants.ENEMY.BLOBSKULL_DARK.HEALTH, function(params)
        return BlobSkullDark(params.origin)
    end),
    ["BLOB-TEETH"] = EnemyBlueprint("NIBBLER", assets.blueprints['blob-teeth'], constants.ENEMY.BLOBTEETH.YIELD, false, {21, 31}, constants.ENEMY.BLOBTEETH.HEALTH, function(params)
        return BlobTeeth(params.origin)
    end),
    ["BLOB-TEETH-DARK"] = EnemyBlueprint("CHOMPER", assets.blueprints['blob-teeth-dark'], constants.ENEMY.BLOBTEETH_DARK.YIELD, false, {26, 31}, constants.ENEMY.BLOBTEETH_DARK.HEALTH, function(params)
        return BlobTeethDark(params.origin)
    end),
    ["BLOB-EYE"] = EnemyBlueprint("SEER", assets.blueprints['blob-eye'], constants.ENEMY.BLOBEYE.YIELD, false, {31, 31}, constants.ENEMY.BLOBEYE.HEALTH, function(params)
        return BlobEye(params.origin)
    end),
}