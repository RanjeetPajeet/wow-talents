----------
-- 
-- 
-- 
----------


local C = C_SpecializationInfo


function TALENT(tabIndex, talentIndex)
    ---
    -- Creates an object representing a talent.
    -- 
    -- Parameters
    -- 
    --     tabIndex: 
    --     talentIndex: 
    -- 
    -- Returns
    -- 
    --     A table with the following:
    ---
    local talent = {};
    local name, iconTexture, tier, column, rank, maxRank, isExceptional, available, previewRank, previewAvailable = GetTalentInfo(tabIndex,talentIndex);
    local requiresLevel = 10 + ((tier-1) * 5)
    
    talent["name"] = name;
    talent["tier"] = tier;
    talent["rank"] = rank;
    talent["maxRank"] = maxRank;
    talent["column"] = column;
    talent["tab"] = tabIndex;
    talent["index"] = talentIndex;
    talent["tree"] = GetTalentTabInfo(tabIndex);
    talent["requiresLevel"] = requiresLevel;

    function talent:Print(self)
        print(self["name"])
        print("  > Tree: ", self["tree"])
        print("  > Rank: ", self["rank"], "/", self["maxRank"])
        print("  > Tier: ", self["tier"], "(requires lvl", self["requiresLevel"] .. ")")
    end

    function talent:Learn(self, numPoints)
        if (numPoints == nil) then
            numPoints = self["rank"]
        end
        for i=1, numPoints do
            C_Timer.After(0.05, function()
                LearnTalent(self["tab"],self["index"])
            end)
        end
    end
end



function PrintAllKnownTalents()
    for tab_index = 1, GetNumTalentTabs() do
        local tabName = GetTalentTabInfo(tab_index)
        print("Tab name:", tabName)
        for talent_index = 1, GetNumTalents(tab_index) do
            local name, iconTexture, tier, column, rank, maxRank, isExceptional, available, previewRank, previewAvailable = GetTalentInfo(tab_index, talent_index)
            if rank > 0 then
                print("  >> Name:", name)
                print("  >> Tier:", tier)
                print("  >> Column:", column)
                print("  >> Rank:", rank)
                print("  >> Max Rank:", maxRank)
                print("  >> Is Exceptional:", isExceptional)
                print("  >> Available:", available)
                print("  >> Preview Rank:", previewRank)
                print("  >> Preview Available:", previewAvailable)
            end
        end
    end
end




function GetKnownTalentsTable()
    local specTable = {}
    local i = 1
    for tab_index = 1, GetNumTalentTabs() do
        for talent_index = 1, GetNumTalents(tab_index) do
            local name, _, tier, column, rank, maxRank = GetTalentInfo(tab_index, talent_index)
            if rank > 0 then
                specTable[i] = {}
                specTable[i].name = name
                -- specTable[i].tier = tier
                specTable[i].tabIndex = tab_index
                specTable[i].talentIndex = talent_index
                specTable[i].column = column
                specTable[i].points = rank
                -- specTable[i].rank = rank
                -- specTable[i].maxRank = maxRank
                i = i + 1
            end
        end
    end
    return specTable
end





function LearnTalentsTable(talentsTable)
    for i = 1, #talentsTable do
        local talent = talentsTable[i]
        for j = 1, talent.points do
            LearnTalent(talent.tabIndex, talent.talentIndex)
        end
    end
end





-- for i = 1, GetNumTalentTabs() do
--     for j = 1, GetNumTalents(i) do
--         print(i, j, GetTalentInfo(i, j))
--     end
-- end
