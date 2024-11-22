-- RMTtest v1.0.0
-- RoRRModdingToolkit - Umigatari/Miguel

log.info("Successfully loaded ".._ENV["!guid"]..".")
mods["RoRRModdingToolkit-RoRR_Modding_Toolkit"].auto() -- Loading the toolkit 

local PATH = _ENV["!plugins_mod_folder_path"]
local NAMESPACE = "RMT"

local initialize = function()
    local jam = Survivor.new(NAMESPACE, "jamman") -- Create a survivor 

    --[[------------------------------------------
        SECTION SPRITES
    ------------------------------------------]]--
    
    -- Load all of our sprites into a table
    local sprites = {
        idle = Resources.sprite_load(NAMESPACE, "jam_idle", path.combine(PATH, "jam", "idle.png"), 1, 6, 20),
        walk = Resources.sprite_load(NAMESPACE, "jam_walk", path.combine(PATH, "jam", "walk.png"), 8, 8, 20),
        jump = Resources.sprite_load(NAMESPACE, "jam_jump", path.combine(PATH, "jam", "jump.png"), 1, 10, 22),
        climb = Resources.sprite_load(NAMESPACE, "jam_climb", path.combine(PATH, "jam", "climb.png"), 2, 8, 14),
        death = Resources.sprite_load(NAMESPACE, "jam_death", path.combine(PATH, "jam", "death.png"), 8, 96, 26),
        
        -- This sprite is used by the Crudely Drawn Buddy
        -- If the player doesn't have one, the Commando's sprite will be used instead
        decoy = Resources.sprite_load(NAMESPACE, "jam_decoy", path.combine(PATH, "jam", "decoy.png"), 1, 18, 36),
    }
    
    -- Attack sprites are loaded separately as we'll be using them in our code
    local sprShoot1 = Resources.sprite_load(NAMESPACE, "jam_shoot1", path.combine(PATH, "jam", "shoot1.png"), 7, 10, 28)
    local sprShoot2 = Resources.sprite_load(NAMESPACE, "jam_shoot2", path.combine(PATH, "jam", "shoot2.png"), 5, 8, 22)
    local sprShoot3 = Resources.sprite_load(NAMESPACE, "jam_shoot3", path.combine(PATH, "jam", "shoot3.png"), 9, 12, 16)
    local sprShoot4 = Resources.sprite_load(NAMESPACE, "jam_shoot4", path.combine(PATH, "jam", "shoot4.png"), 15, 8, 38)
    
    -- The hit sprite used by our X skill
    local sprSparksJam = Resources.sprite_load(NAMESPACE, "jam_sparks1", path.combine(PATH, "jam", "bullet.png"), 4, 20, 16)
    
    -- The spikes creates by our V skill
    local sprJamSpike = Resources.sprite_load(NAMESPACE, "jam_spike", path.combine(PATH, "jam", "spike.png"), 5, 24, 64)
    local sprSparksSpike = Resources.sprite_load(NAMESPACE, "jam_sparks2", path.combine(PATH, "jam", "hitspike.png"), 4, 16, 18)

    -- The sprite used by the skill icons
    local sprSkills = Resources.sprite_load(NAMESPACE, "jam_skills", path.combine(PATH, "jam", "skills.png"), 6, 0, 0)
    
    -- Palette used for alt skins
    local sprPalette = Resources.sprite_load(NAMESPACE, "jam_palette", path.combine(PATH, "jam", "palette.png"))
    local sprSelectPalette = Resources.sprite_load(NAMESPACE, "sSelectJammanPalette", path.combine(PATH, "jam", "sSelectJammanPalette.png"))
    
    -- The rgb color of the character's skill names in the character select
    jam:set_primary_color(Color.from_rgb(162, 62, 224))
    
    -- The character's sprite in the selection pod
    jam.sprite_loadout = Resources.sprite_load(NAMESPACE, "sSelectJamman", path.combine(PATH, "jam", "sSelectJamman.png"), 4, 28, 0)

    -- The character's sprite portrait
    jam.sprite_portrait = Resources.sprite_load(NAMESPACE, "sJammanPortrait", path.combine(PATH, "jam", "sJammanPortrait.png"), 3)
    
    -- The character's sprite small portrait
    jam.sprite_portrait_small = Resources.sprite_load(NAMESPACE, "sJammanPortraitSmall", path.combine(PATH, "jam", "sJammanPortraitSmall.png"))
    -- The character's sprite palettes (WIP)
    jam:set_palettes(sprPalette, sprSelectPalette, sprSelectPalette)
    
    -- Create alternative skin for the survivor
    local jamman_loadout_PAL1 = Resources.sprite_load(NAMESPACE, "sSelectJamman_PAL1", path.combine(PATH, "jam", "sSelectJamman_PAL1.png"), 4, 28, 0)
    local jamman_portrait_PAL1 = Resources.sprite_load(NAMESPACE, "sJammanPortrait_PAL1", path.combine(PATH, "jam", "sJammanPortrait_PAL1.png"), 3)
    local jamman_portraitsmall_PAL1 = Resources.sprite_load(NAMESPACE, "sJammanPortraitSmall_PAL1", path.combine(PATH, "jam", "sJammanPortraitSmall_PAL1.png"))
    jam:add_skin("jammanpurple", 1, jamman_loadout_PAL1, jamman_portrait_PAL1, jamman_portraitsmall_PAL1)
    
    -- Create second alternative skin
    local jamman_loadout_PAL2 = Resources.sprite_load(NAMESPACE, "sSelectJamman_PAL2", path.combine(PATH, "jam", "sSelectJamman_PAL2.png"), 4, 28, 0)
    local jamman_portrait_PAL2 = Resources.sprite_load(NAMESPACE, "sJammanPortrait_PAL2", path.combine(PATH, "jam", "sJammanPortrait_PAL2.png"), 3)
    local jamman_portraitsmall_PAL2 = Resources.sprite_load(NAMESPACE, "sJammanPortraitSmall_PAL2", path.combine(PATH, "jam", "sJammanPortraitSmall_PAL2.png"))
    jam:add_skin("jammanred", 2, jamman_loadout_PAL2, jamman_portrait_PAL2, jamman_portraitsmall_PAL2)

    jam.sprite_title = sprites.walk -- The character's walk animation on the title screen when selected
    jam.sprite_idle = sprites.idle -- The character's idle animation
    jam.sprite_credits = sprites.idle -- The character's idle animation when beating the game

    jam:set_cape_offset(-1, -6, 0, -5) -- Set the Prophet cape offset for the player
    jam:set_animations(sprites) -- Set the player's sprites to those we previously loaded

    --[[------------------------------------------
        SECTION SURVIVOR LOG
    ------------------------------------------]]--

    --  create a new survivor log with the portrait sprite of the survivor as well as the log art
    local log = Survivor_Log.new(jam, jam.sprite_portrait, sprites.jump)

    -- All the log text is in the /elanguage/english.json and is loaded automatically

    --[[------------------------------------------
        SECTION STATS
    ------------------------------------------]]--

    jam:set_stats_base({ -- Set the player's starting stats
        maxhp = 120,
        damage = 22,
        regen = 0.01 -- health regen per frame, so 0.6 per second
    })
    
    jam:set_stats_level({  -- Set the player's leveling stats
        maxhp = 24,
        damage = 4,
        regen = 0.002, -- gain 0.12 health regen per level
        armor = 4
    })
    

    

    --[[------------------------------------------
        SECTION SKILLS
    ------------------------------------------]]--

    --[[
        Subsection Skill General Setups 
    ]]--
    
    -- Get the default survivor skills
    local skill_engage = jam:get_primary()
    local skill_raspberry = jam:get_secondary()
    local skill_roll = jam:get_utility()
    local skill_spikes = jam:get_special()
    
    -- Create a new alt skill for the secondary skill
    local skill_spoiled = Skill.new(NAMESPACE, "jammanX2")
    jam:add_secondary(skill_spoiled)

    -- Create a new skill for the special skill upgrade
    local skill_spikesScepter = Skill.new(NAMESPACE, "jammanVBoosted")
    skill_spikes:set_skill_upgrade(skill_spikesScepter)
    
    -- Set the animation for each skills
    skill_engage:set_skill_animation(sprShoot1)
    skill_raspberry:set_skill_animation(sprShoot2)
    skill_spoiled:set_skill_animation(sprShoot2)
    skill_roll:set_skill_animation(sprShoot3)
    skill_spikes:set_skill_animation(sprShoot4)
    skill_spikesScepter:set_skill_animation(sprShoot4)

    -- Create 1 State for every Skill
    local state_stab = State.new(NAMESPACE, skill_engage.identifier)
    local state_raspberry = State.new(NAMESPACE, skill_raspberry.identifier)
    local state_spoiled = State.new(NAMESPACE, skill_spoiled.identifier)
    local state_roll = State.new(NAMESPACE, skill_roll.identifier)
    local state_spikes = State.new(NAMESPACE, skill_spikes.identifier)
    local state_spikesScepter = State.new(NAMESPACE, skill_spikesScepter.identifier)

    --[[
        Subsection Primary Skill 
    ]]--

    -- Setup the Primary skill sprite, as well damage and cooldown properties
    skill_engage:set_skill_icon(sprSkills, 0) 
    skill_engage:set_skill_properties(1, 20) -- 100% of base damage, 20 frames cooldown


    skill_engage:set_skill_stock(6, 6, 0, 0)


    -- the onActivate callback is called when the player tries to use its primary skill
    skill_engage:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_stab)
    end)

    -- Reset the sprite animation to frame 0 when you enter the state
    state_stab:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)
    
-- Implement the actual mechanics of the skill inside of the state
state_stab:onStep(function(actor, data)
    -- Fix the horizontal speed of the survivor (maybe when it switches states?)
    actor:skill_util_fix_hspeed()
    
    -- Get the animation from the skill and set it for this state with a custom speed
    if actor:get_active_skill(Skill.SLOT.primary).stock >= 1 then
    actor:actor_animation_set(actor:actor_get_skill_animation(skill_raspberry), 0.30)
    else
    actor:actor_animation_set(actor:actor_get_skill_animation(skill_engage), 0.25)
    end
    
    -- Check if we already fired and 
    -- if the animation is frame number is greater or equal to 4
    -- Used to fire only once per activation and at a specific frame
    if data.fired == 0 and actor.image_index >= 4.0 then

        -- Get the damage coeff from the skill
        local damage = actor:skill_get_damage(skill_engage)
        
        -- Check if the actor is the host (sometimes used if we only want the host to trigger it)
        -- (mostly for networked things)
        if actor:is_authority() then

            -- Check if we are not firing the heaven cracker
            if not actor:skill_util_update_heaven_cracker(actor, damage) then

                -- Get the shattered mirror buff
                local buff_shadow_clone = Buff.find("ror", "shadowClone")

                -- Fire an attack for each clone of the survivor (from shattered mirror)
                for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do

                    -- Fire an explosion from the survivor
                    
           
                    if actor:get_active_skill(Skill.SLOT.primary).stock >= 1 then
                    local attack = GM._mod_attack_fire_explosion(actor, actor.x + gm.cos(gm.degtorad(actor:skill_util_facing_direction())) * 80, actor.y, 200, 120, damage, gm.constants.sEnforcerGrenadeExplosion, gm.constants.sSparks7)
                    attack.max_hit_number = 5
                    attack.attack_info.climb = i * 8
                    actor:sound_play(gm.constants.wEnforcerShoot1, 1, 0.8 + math.random() * 0.2)
                    actor:get_active_skill(Skill.SLOT.primary).stock = actor:get_active_skill(Skill.SLOT.primary).stock - 1
                    else
                    local attack = GM._mod_attack_fire_explosion(actor, actor.x + gm.cos(gm.degtorad(actor:skill_util_facing_direction())) * 25, actor.y, 40, 60, damage, -1, gm.constants.sSparks7)
                    attack.attack_info.knockback_kind = 1
                    actor:sound_play(gm.constants.wClayShoot1, 1, 0.8 + math.random() * 0.2)
                                        -- Specify how many enemies should be hit by the explosion
                    attack.max_hit_number = 5

                    -- Offset the displayed damage number for each clone
                    attack.attack_info.climb = i * 8
                    end
                end
            end
        end

        -- Play a sound at the player's location
        -- (sound_id, volume, pitch)
        

        -- Tell that we fired
        data.fired = 1
    end

    -- Auto exit the state when the animation is finished
    actor:skill_util_exit_state_on_anim_end()
end)
    --[[
        Subsection Secondary Skill 
    ]]--

    -- Setup the Secondary skill sprite, as well damage and cooldown properties
    skill_raspberry:set_skill_icon(sprSkills, 1)
    skill_raspberry:set_skill_properties(1, 4 * 60)

    -- When the player tries to activate his Secondary skill, switch his state
    skill_raspberry:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_raspberry)
    end)


    -- Reset the sprite animation to frame 0 when entering the state
    state_raspberry:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)
    
    -- Implement the actual mechanics of the skill inside of the state, 
    state_raspberry:onStep(function(actor, data)
        -- Fix the horizontal speed of the survivor (maybe when it switches states?)
        actor:skill_util_fix_hspeed()
        
        -- Get the animation from the skill and set it for this state with a custom speed
        actor:actor_animation_set(actor:actor_get_skill_animation(skill_raspberry), 0.25)

        -- Check if we already fired and 
        -- if the animation is frame number is greater or equal to 4
        -- Used to fire only once per activation and at a specific frame
        if data.fired == 0 and actor.image_index >= 1.0 then
            local damage = actor:skill_get_damage(skill_raspberry)
            
            -- Check if the actor is the host (sometimes used if we only want the host to trigger it)
            -- (mostly for networked things)
            if actor:is_authority() then
            if actor:get_active_skill(Skill.SLOT.primary).stock >= 1 then
                local buff_shadow_clone = Buff.find("ror", "shadowClone")
                for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                    local attack = GM._mod_attack_fire_explosion(actor, actor.x + gm.cos(gm.degtorad(actor:skill_util_facing_direction())) * 80, actor.y, 200, 120, damage*actor:get_active_skill(Skill.SLOT.primary).stock, gm.constants.sEnforcerGrenadeExplosion, gm.constants.sSparks7)
                    actor:get_active_skill(Skill.SLOT.primary).stock = 0
                end 
            end
        end

            actor:sound_play(gm.constants.wBullet2, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    jam:add_instance_callback(function(obj_inst, hit_inst, hit_x, hit_y)
        if not obj_inst.jamdot or hit_inst.dead == nil then return end
    
        local dot = GM.instance_create(hit_x, hit_y, gm.constants.oDot)
        dot.target = hit_inst.id
        dot.parent = obj_inst.attack_info.parent.id
        dot.damage = obj_inst.attack_info.damage /4
        dot.ticks = 3
        dot.team = obj_inst.attack_info.team
        dot.textColor = Color.RED
        dot.sprite_index = gm.constants.sSparks9
    end)
    
    --[[
        Subsection Secondary Alt Skill 
    ]]--
    
    -- Setup the Secondary alt skill sprite, as well damage and cooldown properties
    skill_spoiled:set_skill_icon(sprSkills, 2)
    skill_spoiled:set_skill_properties(2.4, 6 * 60)

    -- Called when the player tries to use its secondary alt skill
    skill_spoiled:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_spoiled)
    end)

    -- Reset the sprite animation to frame 0
    state_spoiled:onEnter(function(actor, data)
        actor.image_index = 0
        data.fired = 0
    end)
    
    -- Implement the actual mechanics of the skill
    state_spoiled:onStep(function(actor, data)

        actor:skill_util_fix_hspeed()
        
        actor:actor_animation_set(actor:actor_get_skill_animation(skill_spoiled), 0.25)

        if data.fired == 0 and actor.image_index >= 1.0 then
            local damage = actor:skill_get_damage(skill_spoiled)
            
            if actor:is_authority() then
                local buff_shadow_clone = Buff.find("ror", "shadowClone")
                for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                    local attack = GM._mod_attack_fire_bullet(actor, actor.x, actor.y, 500, actor:skill_util_facing_direction(), damage, sprSparksJam, true, true)
                    attack.attack_info.attack_flags = 1 << 1
                    attack.attack_info.climb = i * 8
                end
            end

            actor:sound_play(gm.constants.wBullet2, 1, 0.9 + math.random() * 0.2)
            data.fired = 1
        end

        actor:skill_util_exit_state_on_anim_end()
    end)

    --[[
        Subsection Utility Skill 
    ]]--

    -- Setup the Utility skill sprite, as well damage and cooldown properties
    skill_roll:set_skill_icon(sprSkills, 3)
    skill_roll:set_skill_properties(1, 1 * 60)

    -- Called when the player tries to use its utility skill
    skill_roll:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_roll)
        if actor:get_active_skill(Skill.SLOT.primary).stock < 6 then
        actor:sound_play(gm.constants.wReload, 1, 0.9 + math.random() * 0.2)
        actor:actor_skill_add_stock(actor, 0, false, 1)     -- actor, slot, ignore cap, raw value
        else

        end
    end)

    -- Reset the sprite animation to frame 0
    state_roll:onEnter(function(actor, data)
        actor.image_index = 0
    end)
    





    -- Implement the actual mechanics of the skill
    state_roll:onStep(function(actor, data)
        --actor:skill_util_fix_hspeed()
        
        actor.sprite_index = actor:actor_get_skill_animation(skill_roll)
        actor.image_speed = 0.8


        

            
        actor:skill_util_exit_state_on_anim_end()
    end)






    --[[
        Subsection Special Skill 
    ]]--

    -- Setup the Special skill sprite, as well damage and cooldown properties
    skill_spikes:set_skill_icon(sprSkills, 4)
    skill_spikes:set_skill_properties(3, 7 * 60)

    -- Called when the player tries to use its special skill
    skill_spikes:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_spikes)
    end)

    -- Reset the sprite animation to frame 0
    state_spikes:onEnter(function(actor, data)
        actor.image_index = 0
        data.spikes = 3
    end)
    
    -- Implement the actual mechanics of the skill
    state_spikes:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()
        
        actor:actor_animation_set(actor:actor_get_skill_animation(skill_spikes.value), 0.25)

        if (data.spikes == 3 and actor.image_index >= 6.0) or (data.spikes == 2 and actor.image_index >= 10.0) or (data.spikes == 1 and (actor.image_index >= 14.0 or actor.image_index >= 13.9)) then
            local damage = actor:skill_get_damage(skill_spikes)
            
            if actor:is_authority() then
                if not actor:skill_util_update_heaven_cracker(actor, damage) then
                    local buff_shadow_clone = Buff.find("ror", "shadowClone")
                    for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                        -- Calculate the offset from the player
                        local pos = ((actor.image_index - 2) / 4) * 48 + i * 12

                        -- Create the spike
                        local attack = GM._mod_attack_fire_explosion(actor, actor.x + GM.cos(GM.degtorad(actor:skill_util_facing_direction())) * pos, actor.y, 80, 120, damage, sprJamSpike, sprSparksSpike)
                        attack.attack_info.climb = i * 8
                    end
                end
            end

            actor:sound_play(gm.constants.wBoss1Shoot1, 1, 1.2 + math.random() * 0.3)          
            data.spikes = data.spikes - 1  
        end
        
        actor:skill_util_exit_state_on_anim_end()
    end)

    --[[
        Subsection Special Upgraded Skill 
    ]]--

    -- Setup the Special Upgrade skill sprite, as well damage and cooldown properties
    skill_spikesScepter:set_skill_icon(sprSkills, 5)
    skill_spikesScepter:set_skill_properties(8, 7 * 60)

    -- Called when the player tries to use its special upgrade skill
    skill_spikesScepter:onActivate(function(actor, skill, index)
        GM.actor_set_state(actor, state_spikesScepter)
    end)

    -- Reset the sprite animation to frame 0
    state_spikesScepter:onEnter(function(actor, data)
        actor.image_index = 0
        data.spikes = 3
    end)
    
    -- Implement the actual mechanics of the skill
    state_spikesScepter:onStep(function(actor, data)
        actor:skill_util_fix_hspeed()
        
        actor:actor_animation_set(actor:actor_get_skill_animation(skill_spikesScepter), 0.25)

        if (data.spikes == 3 and actor.image_index >= 6.0) or (data.spikes == 2 and actor.image_index >= 10.0) or (data.spikes == 1 and (actor.image_index >= 14.0 or actor.image_index >= 13.9)) then
            local damage = actor:skill_get_damage(skill_spikesScepter.damage)
            
            if actor:is_authority() then
                if not actor:skill_util_update_heaven_cracker(actor, damage) then
                    local buff_shadow_clone = Buff.find("ror", "shadowClone")
                    for i=0, GM.get_buff_stack(actor, buff_shadow_clone) do
                        -- Calculate the offset from the player
                        local pos = ((actor.image_index - 2) / 4) * 48 + i * 12

                        -- Create the spike
                        local attack1 = GM._mod_attack_fire_explosion(actor, actor.x + GM.cos(GM.degtorad(actor:skill_util_facing_direction())) * pos, actor.y, 80, 120, damage, sprJamSpike, sprSparksSpike)
                        local attack2 = GM._mod_attack_fire_explosion(actor, actor.x - GM.cos(GM.degtorad(actor:skill_util_facing_direction())) * pos, actor.y, 80, 120, damage, sprJamSpike, sprSparksSpike)
                        attack1.attack_info.climb = i * 8
                        attack2.attack_info.climb = i * 8
                    end
                end
            end

            -- Layer sound effects when scepter is active
            actor:sound_play(gm.constants.wGuardDeath, 0.6, 1.2 + math.random() * 0.3)            
            actor:sound_play(gm.constants.wBoss1Shoot1, 1, 1.2 + math.random() * 0.3)
            data.spikes = data.spikes - 1          
        end
        
        actor:skill_util_exit_state_on_anim_end()
    end)
end

-- use this code to hot_reload the mod
if hot_reloading then
    initialize()
else 
    Initialize(initialize)
end
hot_reloading = true
