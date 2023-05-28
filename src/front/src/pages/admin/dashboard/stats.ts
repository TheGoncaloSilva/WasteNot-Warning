import { BE_API } from '../../../services/backend-api/backend-api';
import { NEXT_MAINTENANCE } from '../../../services/backend-api/interfaces';

export const getNextMaintenance = async () => {
    return await (async() => {
        const res: NEXT_MAINTENANCE[] = await BE_API.get_next_maintenance();
        
        // Only get the next two
        if (res.length > 2) {
            res.splice(2); // Remove all elements starting from index 2
        }
        return res;
    })();
  };